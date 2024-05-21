//
//  KodiPlayerView.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import SwiftUI
@preconcurrency import AVKit

// MARK: Kodi Player View

/// SwiftUI View with a player to stream a ``KodiItem`` (SwiftlyKodi Type)
///
/// - It is using the Apple `AVplayer` so it only supports *Apple Approved* formats.
/// - If your media is on a harddisk and it's sleeping; the media will sometimes not start because of a timeout. Try again and it will work.
public struct KodiPlayerView: View {
    /// The Video item we want to play
    let video: any KodiItem
    /// Resume the video or not
    let resume: Bool
    /// The host
    let host: HostItem
    /// Observe the player
    @StateObject private var playerModel: KodiPlayerModel
    /// The dismiss action
    @Environment(\.dismiss)
    private var dismiss
#if os(visionOS)
    @Environment(\.dismissImmersiveSpace)
    var dismissImmersiveSpace
#endif
    /// Init the View: we don't get it for free
    /// - Parameters:
    ///   - video: The ``KodiItem`` to play
    ///   - resume: `Bool` if the item must be resumed or not
    public init(host: HostItem, video: any KodiItem, resume: Bool = false) {
        self.video = video
        self.resume = resume
        self.host = host
        self._playerModel = StateObject(wrappedValue: KodiPlayerModel(host: host))
    }
    /// The body of the View
    public var body: some View {
        VideoPlayer(player: playerModel.player)
#if os(visionOS)
            .toolbar(id: "Player") {
                ToolbarItem(
                    id: "closeButton",
                    placement: .bottomOrnament,
                    showsByDefault: true
                ) {
                    Button(
                        action: {
                            /// visionOS does not call .onDissapear, so this is a workaround:
                            endAction()
                            dismiss()
                            Task {
                                await dismissImmersiveSpace()
                            }
                        },
                        label: {
                            Label("Close", systemImage: "xmark")
                        }
                    )
                    .labelStyle(.titleAndIcon)
                }
            }
#endif
#if os(iOS)
        /// Show a close button to exit the video
            .overlay(alignment: .topLeading) {
                Button(
                    action: {
                        dismiss()
                    },
                    label: {
                        Image(systemName: "x.circle")
                            .font(.largeTitle)
                            .foregroundColor(.white.opacity(0.5))
                    }
                )
            }
#endif
            .task(id: playerModel.state) {
                switch playerModel.state {
                case .load:
                    playerModel.loadVideo(video: video)
                case .readyToPlay:
                    if resume, video.resume.position > 0 {
                        let time = CMTime(seconds: video.resume.position, preferredTimescale: 1)
                        await playerModel.player.seek(to: time)
                    }
                    playerModel.state = .playing
                    /// Start the player
                    playerModel.player.play()
                case .playing:
                    break
                case .end:
                    dismiss()
                }
            }
            .ignoresSafeArea(.all)
        /// This got not called on visionOS:
            .onDisappear {
                endAction()
            }
    }

    func endAction() {
        Task {
            switch playerModel.state {
            case .playing:
                /// Video is playing, set resume point
                /// - Note: Not exacly as Kodi does it and ignoring 'advancedsettings'
                if let time = playerModel.player.currentItem?.currentTime() {
                    let percentage = time.seconds / Double(video.duration)
                    if percentage > 0.9 {
                        /// A video that is almost done will be marked as played
                        await video.markAsPlayed(host: host)
                    } else if time.seconds > 180 {
                        /// Set resume point
                        await video.setResumeTime(host: host, time: time.seconds)
                    }
                }
            case .end:
                /// End of video, mark as played
                await video.markAsPlayed(host: host)
            default:
                break
            }
            /// Stop the video
            playerModel.player.replaceCurrentItem(with: nil)
            /// Stop the timer
            playerModel.timer.invalidate()
        }
    }
}

/// The KodiPlayerModel class
final class KodiPlayerModel: ObservableObject, @unchecked Sendable {
    /// Init the class
    init(host: HostItem) {
        self.host = host
    }

    // swiftlint:disable implicitly_unwrapped_optional
    /// The AVplayer
    var player: AVPlayer!
    /// The timer to keep an eye on the player
    var timer: Timer!
    // swiftlint:enable implicitly_unwrapped_optional
    /// The state of the player
    @Published var state: KodiPlayerState = .load
    /// The current host
    let host: HostItem

    /// All the states of the player
    enum KodiPlayerState {
        case load
        case readyToPlay
        case playing
        case end
    }

    /// Load a video into the player
    /// - Parameter video: The ``KodiItem`` to play
    func loadVideo(video: any KodiItem) {
        // swiftlint:disable:next force_unwrapping
        let playerItem = AVPlayerItem(url: URL(string: Files.getFullPath(host: host, file: video.file, type: .file))!)
#if os(tvOS)
        /// tvOS can add aditional info to the player
        Task {
            playerItem.externalMetadata = await createMetadataItems(video: video)
        }
#endif
        /// Create a new Player
        player = AVPlayer(playerItem: playerItem)
        player.actionAtItemEnd = .none
        /// Prevent display sleeping while playing
#if os(macOS) || os(tvOS) || os(iOS)
        player.preventsDisplaySleepDuringVideoPlayback = true
#endif
        /// Get a notification when the video has ended
        NotificationCenter
            .default
            .addObserver(
                forName: .AVPlayerItemDidPlayToEndTime,
                object: nil,
                queue: nil
            ) { _ in
                Task { @MainActor in
                    self.state = .end
                }
            }
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            self.stateObserver()
        }
    }
    /// Check if the player is ready to play
    func stateObserver() {
        if player.readyToPlay {
            Task { @MainActor in
                state = .readyToPlay
            }
            timer.invalidate()
        }
    }


#if os(tvOS)

    /// Create meta data for the video player
    /// - Parameter video: The Kodi video item
    /// - Returns: Meta data for the player
    func createMetadataItems(video: any KodiItem) async -> [AVMetadataItem] {

        /// The Metadata of the video
        var metaData = MetaData()

        /// The structure for metadata
        struct MetaData {
            var title: String = "title"
            var subtitle: String = "subtitle"
            var description: String = "description"
            var genre: String = "genre"
            var creationDate: String = "1900"
            // swiftlint:disable force_unwrapping
            var artwork: UIImage = UIImage(
                named: "poster",
                in: Bundle.module,
                compatibleWith: nil) ?? UIImage(systemName: "film"
                )!
            // swiftlint:enable force_unwrapping
        }

        /// Helper function to create the metadata
        /// - Parameters:
        ///   - identifier: The key
        ///   - value: The value
        /// - Returns: An `AVMetadataItem`
        func createMetadataItem(for identifier: AVMetadataIdentifier, value: Any) -> AVMetadataItem {
            let item = AVMutableMetadataItem()
            item.identifier = identifier
            item.value = value as? NSCopying & NSObjectProtocol
            /// Specify "und" to indicate an undefined language.
            item.extendedLanguageTag = "und"
            // swiftlint:disable:next force_cast
            return item.copy() as! AVMetadataItem
        }

        /// Get the poster of the item
        /// - Parameter file: The internal Kodi file of the art
        /// - Returns: An `UIImage`
        func getArtwork(file: String) async -> UIImage {
            if !file.isEmpty, let url = URL(string: Files.getFullPath(host: host, file: file, type: .art)) {
                if let (data, _) = try? await URLSession.shared.data(from: url) {
                    if let image = UIImage(data: data) {
                        return image
                    }
                }
            }
            // swiftlint:disable:next force_unwrapping
            return UIImage(named: "poster", in: Bundle.module, compatibleWith: nil) ?? UIImage(systemName: "film")!
        }

        /// Set the MetaData
        switch video {
        case let movie as Video.Details.Movie:
            metaData.title = movie.title
            metaData.subtitle = movie.tagline
            metaData.description = movie.plot
            metaData.artwork = await getArtwork(file: movie.art.poster)
            metaData.genre = movie.genre.joined(separator: " ∙ ")
            metaData.creationDate = movie.year.description
        case let episode as Video.Details.Episode:
            metaData.title = episode.title
            metaData.subtitle = episode.showTitle
            metaData.description = episode.plot
            metaData.artwork = await getArtwork(file: episode.art.seasonPoster)
            metaData.genre = episode.showTitle
            metaData.creationDate = "\(episode.firstAired)"
        case let musicVideo as Video.Details.MusicVideo:
            metaData.title = musicVideo.title
            metaData.subtitle = musicVideo.subtitle
            metaData.description = musicVideo.plot
            metaData.artwork = await getArtwork(file: musicVideo.art.poster)
            metaData.genre = musicVideo.genre.joined(separator: " ∙ ")
            metaData.creationDate = musicVideo.year.description
        default:
            break
        }
        let mapping: [AVMetadataIdentifier: Any] = [
            .commonIdentifierTitle: metaData.title,
            .iTunesMetadataTrackSubTitle: metaData.subtitle,
            .commonIdentifierArtwork: metaData.artwork.pngData() as Any,
            .commonIdentifierDescription: metaData.description,
            .quickTimeMetadataGenre: metaData.genre,
            .iTunesMetadataReleaseDate: metaData.creationDate.utf8,
            .quickTimeMetadataCreationDate: metaData.creationDate.utf8,
            .commonIdentifierCreationDate: metaData.creationDate.utf8,
            .quickTimeUserDataCreationDate: metaData.creationDate.utf8
        ]
        return mapping.compactMap { createMetadataItem(for: $0, value: $1) }
    }
#endif
}
extension AVPlayer {

    /// Bool if the Player is ready to play
    ///
    /// https://stackoverflow.com/questions/5401437/knowing-when-avplayer-object-is-ready-to-play
    var readyToPlay: Bool {
        let timeRange = currentItem?.loadedTimeRanges.first as? CMTimeRange
        guard let duration = timeRange?.duration else {
            return false
        }
        /// value/timescale = seconds
        let timeLoaded = Int(duration.value) / Int(duration.timescale)
        let loaded = timeLoaded > 0
        /// Return the status
        return status == .readyToPlay && loaded
    }
}

extension AVPlayer {

    /// Is the AV player playing or not?
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
