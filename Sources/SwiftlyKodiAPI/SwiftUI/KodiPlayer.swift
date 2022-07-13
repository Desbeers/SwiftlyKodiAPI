//
//  PlayerView.swift
//  Komodio
//
//  Created by Nick Berendsen on 26/02/2022.
//
import SwiftUI
import Combine
import AVKit

/// A View with the player
public struct KodiPlayerView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The Video item we want to play
    let video: any KodiItem
    /// init: we don't get it for free
    public init(video: any KodiItem) {
        self.video = video
    }
    /// The presentation mode
    /// - Note: Need this to go back a View on iOS after the video has finnished
    @Environment(\.presentationMode) var presentationMode
    /// The body of this View
    public var body: some View {
        Wrapper(video: video) {
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
        //let video: MediaItem
        /// Observe the player
        @StateObject private var playerModel: PlayerModel
        /// Init the Wrapper View
        init(video: any KodiItem, endAction: @escaping () -> Void) {
            //self.video = video
            _playerModel = StateObject(wrappedValue: PlayerModel(video: video, endAction: endAction))
        }
        /// The body of this View
        var body: some View {
            VideoPlayer(player: playerModel.player)
                .task {
                    /// Check if we are already playing or not
                    if playerModel.player.isPlaying == false {
                        print("INFO start player")
                        playerModel.player.play()
                    }
                }
                .ignoresSafeArea(.all)
        }
        /// The PlayerModel class
        class PlayerModel: ObservableObject {
            /// The AVplayer
            let player: AVPlayer
            /// Init the PlayerModel class
            init(video: any KodiItem, endAction: @escaping () -> Void) {
                /// Setup the player
                let playerItem = AVPlayerItem(url: URL(string: Files.getFullPath(file: video.file, type: .file))!)
                print("INFO start metadata")
#if os(tvOS)
                /// tvOS can add aditional info to the player
                playerItem.externalMetadata = createMetadataItems(video: video)
#endif
                print("INFO end metadata")
                /// Create a new Player
                print("INFO create player")
                player = AVPlayer(playerItem: playerItem)
                player.actionAtItemEnd = .none
                /// Get notifications
                NotificationCenter
                    .default.addObserver(forName: .AVPlayerItemDidPlayToEndTime,
                                         object: nil,
                                         queue: nil) { _ in endAction() }
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
        metaData.creationDate = episode.firstAired
//    case let musicVideo as Video.Details.MusicVideo:
    default:
        break
    }
    let mapping: [AVMetadataIdentifier: Any] = [
        .commonIdentifierTitle: metaData.title,
        .iTunesMetadataTrackSubTitle: metaData.subtitle,
        .commonIdentifierArtwork: metaData.artwork.pngData() as Any,
        .commonIdentifierDescription: metaData.description,
        /// .iTunesMetadataContentRating: "100",
        .quickTimeMetadataGenre: metaData.genre,
        .quickTimeMetadataCreationDate: metaData.creationDate
        //.commonIdentifierTitle: video.title,
        //.iTunesMetadataTrackSubTitle: video.subtitle,
        //.commonIdentifierArtwork: artData!.pngData() as Any,
        //.commonIdentifierDescription: video.description,
        /// .iTunesMetadataContentRating: "100",
        //.quickTimeMetadataGenre: video.genres.joined(separator: "・"),
        //.quickTimeMetadataCreationDate: video.releaseDate.kodiDate()
    ]
    return mapping.compactMap { createMetadataItem(for: $0, value: $1) }
}
#endif
extension AVPlayer {
    
    /// Is the AV player playing or not?
    var isPlaying: Bool {
        return rate != 0 && error == nil
    }
}
