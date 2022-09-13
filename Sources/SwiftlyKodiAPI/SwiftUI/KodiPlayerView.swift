//
//  KodiPlayerView.swift
//  Komodio
//
//  Created by Nick Berendsen on 26/02/2022.
//
import SwiftUI
import Combine
import AVKit

/// A SwiftUI View with a player to stream a ``KodiItem`` (SwiftlyKodi Type)
public struct KodiPlayerView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The Video item we want to play
    let video: any KodiItem
    /// Resume the video or not
    let resume: Bool
    
    @State private var playing: Bool = false
    
    /// init: we don't get it for free
    public init(video: any KodiItem, resume: Bool = false) {
        self.video = video
        self.resume = resume
    }
    /// The presentation mode
    /// - Note: Need this to go back a View on iOS after the video has finnished
    @Environment(\.presentationMode) var presentationMode
    /// The body of this View
    public var body: some View {
        Wrapper(video: video, resume: resume) {
            /// Mark the video as played
            Task {
                await video.markAsPlayed()
            }
            /// Go back a View
            presentationMode.wrappedValue.dismiss()
        }
    }
}

extension KodiPlayerView {
    
    /// A wrapper View around the `VideoPlayer` so we can observe it
    /// and act after a video has finnised playing
    struct Wrapper: View {
        /// The video we want to play
        let video: any KodiItem
        /// Resume the video or not
        let resume: Bool
        /// Player is ready and playing
        @State private var isPlaying: Bool = false
        /// Observe the player
        @StateObject private var playerModel: PlayerModel
        /// Init the Wrapper View
        init(video: any KodiItem, resume: Bool, endAction: @escaping () -> Void) {
            self.video = video
            self.resume = resume
            _playerModel = StateObject(wrappedValue: PlayerModel(video: video, endAction: endAction))
        }
        /// The body of this View
        var body: some View {
            TimelineView(.periodic(from: .now, by: 1.0)) { timeline in
                VideoPlayer(player: playerModel.player)
                    .task(id: playerModel.player.readyToPlay) {
                        if playerModel.player.readyToPlay, !isPlaying {
                            if resume, video.resume.position > 0 {
                                let time = CMTime(seconds: video.resume.position, preferredTimescale: 1)
                                playerModel.player.seek(to: time)
                            }
                            /// Don't do this again
                            isPlaying = true
                            /// Start the player
                            playerModel.player.play()
                        }
                    }
            }
            .ignoresSafeArea(.all)
            .onDisappear {
                dump(playerModel.player.status.rawValue)
            }
        }
        /// The PlayerModel class
        class PlayerModel: ObservableObject {
            /// The AVplayer
            @Published var player: AVPlayer
            private var timeObservation: Any?
            /// Init the PlayerModel class
            init(video: any KodiItem, endAction: @escaping () -> Void) {
                /// Setup the player
                let playerItem = AVPlayerItem(url: URL(string: Files.getFullPath(file: video.file, type: .file))!)
#if os(tvOS)
                /// tvOS can add aditional info to the player
                playerItem.externalMetadata = createMetadataItems(video: video)
#endif
                /// Create a new Player
                player = AVPlayer(playerItem: playerItem)
                player.actionAtItemEnd = .none
                /// Periodically observe the player's current time, whilst playing and set the resume point
                timeObservation = player.addPeriodicTimeObserver(forInterval: CMTime(seconds: 10, preferredTimescale: 600), queue: nil) { time in
                    Task {
                        await KodiConnector.shared.task.setResumeTime.submit {
                            print("Set resume point")
                            await video.setResumeTime(time: time.seconds)
                        }
                    }
                }
                /// Get notifications
                NotificationCenter
                    .default
                    .addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                 object: nil,
                                 queue: nil) { _ in
                        endAction()
                        
                    }
            }
        }
    }
}

#if os(tvOS)

/// Create meta data for the video player
/// - Parameter video: The Kodi video item
/// - Returns: Meta data for the player
func createMetadataItems(video: any KodiItem) -> [AVMetadataItem] {
    
    /// Meta data struct
    struct MetaData {
        var title: String = "title"
        var subtitle: String = "subtitle"
        var description: String = "description"
        var genre: String = "genre"
        var creationDate: String = "1900"
        var artwork: UIImage = UIImage(named: "poster", in: Bundle.module, compatibleWith: .current)!
    }
    
    /// Helper function
    func createMetadataItem(for identifier: AVMetadataIdentifier, value: Any) -> AVMetadataItem {
        let item = AVMutableMetadataItem()
        item.identifier = identifier
        item.value = value as? NSCopying & NSObjectProtocol
        // Specify "und" to indicate an undefined language.
        item.extendedLanguageTag = "und"
        return item.copy() as! AVMetadataItem
    }
    
    var metaData = MetaData()
    
    switch video {
    case let movie as Video.Details.Movie:
        metaData.title = movie.title
        metaData.subtitle = movie.tagline
        metaData.description = movie.plot
        if !movie.art.poster.isEmpty, let data = try? Data(contentsOf: URL(string: Files.getFullPath(file: movie.art.poster, type: .art))!) {
            if let image = UIImage(data: data) {
                metaData.artwork = image
            }
        }
        metaData.genre = movie.genre.joined(separator: " ∙ ")
        metaData.creationDate = movie.year.description
    case let episode as Video.Details.Episode:
        metaData.title = episode.title
        metaData.subtitle = episode.showTitle
        metaData.description = episode.plot
        if !episode.art.seasonPoster.isEmpty, let data = try? Data(contentsOf: URL(string: Files.getFullPath(file: episode.art.seasonPoster, type: .art))!) {
            if let image = UIImage(data: data) {
                metaData.artwork = image
            }
        }
        metaData.genre = episode.showTitle
        metaData.creationDate = "\(episode.firstAired)"
    case let musicVideo as Video.Details.MusicVideo:
        metaData.title = musicVideo.title
        metaData.subtitle = musicVideo.subtitle
        metaData.description = musicVideo.plot
        if !musicVideo.art.poster.isEmpty, let data = try? Data(contentsOf: URL(string: Files.getFullPath(file: musicVideo.art.poster, type: .art))!) {
            if let image = UIImage(data: data) {
                metaData.artwork = image
            }
        }
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

extension AVPlayer {
    
    
    /// Bool if the Player is ready to play
    ///
    /// https://stackoverflow.com/questions/5401437/knowing-when-avplayer-object-is-ready-to-play
    var readyToPlay:Bool {
        let timeRange = currentItem?.loadedTimeRanges.first as? CMTimeRange
        guard let duration = timeRange?.duration else { return false }
        let timeLoaded = Int(duration.value) / Int(duration.timescale) // value/timescale = seconds
        let loaded = timeLoaded > 0
        
        return status == .readyToPlay && loaded
    }
}

extension AVPlayer {
    
    /// Is the AV player playing or not?
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
