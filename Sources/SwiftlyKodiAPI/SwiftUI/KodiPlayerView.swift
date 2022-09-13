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
    /// The Video item we want to play
    let video: any KodiItem
    /// Resume the video or not
    let resume: Bool
    /// Observe the player
    @StateObject private var playerModel = KodiPlayerModel()
    /// The presentation mode
    /// - Note: Need this to go back a View on iOS after the video has finnished
    @Environment(\.presentationMode) var presentationMode
    
    /// init: we don't get it for free
    public init(video: any KodiItem, resume: Bool = false) {
        self.video = video
        self.resume = resume
    }
    /// The body of this View
    public var body: some View {
        VideoPlayer(player: playerModel.player)
            .task(id: playerModel.state) {
                switch playerModel.state {
                case .load:
                    playerModel.loadVideo(video: video)
                case .readyToPlay:
                    if resume, video.resume.position > 0 {
                        let time = CMTime(seconds: video.resume.position, preferredTimescale: 1)
                        playerModel.player.seek(to: time)
                    }
                    playerModel.state = .playing
                    /// Start the player
                    playerModel.player.play()
                case .playing:
                    break
                case .end:
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .ignoresSafeArea(.all)
            .onDisappear {
                Task {
                    switch playerModel.state {
                    case .playing:
                        print("Video is playing, set resume point")
                        if let time = playerModel.player.currentItem?.currentTime() {
                            await video.setResumeTime(time: time.seconds)
                        }
                    case .end:
                        print("End of video, mark as played")
                        await video.markAsPlayed()
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
}

enum KodiPlayerState {
    case load
    case readyToPlay
    case playing
    case end
}

/// The KodiPlayerModel class
class KodiPlayerModel: ObservableObject {
    /// The AVplayer
    var player: AVPlayer!
    
    var timer: Timer!
    @Published var state: KodiPlayerState = .load
    
    func loadVideo(video: any KodiItem) {
        
        
        
        /// Setup the player
        let playerItem = AVPlayerItem(url: URL(string: Files.getFullPath(file: video.file, type: .file))!)
#if os(tvOS)
        /// tvOS can add aditional info to the player
        playerItem.externalMetadata = createMetadataItems(video: video)
#endif
        /// Create a new Player
        player = AVPlayer(playerItem: playerItem)
        player.actionAtItemEnd = .none
        /// Get a notification when the video has ended
        NotificationCenter
            .default
            .addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                         object: nil,
                         queue: nil) { _ in
                Task { @MainActor in
                    self.state = .end
                }
            }
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
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
    var readyToPlay: Bool {
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
