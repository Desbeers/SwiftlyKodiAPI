//
//  KodiArt.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import SwiftUI
import Kingfisher


/// SwiftUI Views for Kodi art (SwiftlyKodi Type)
///
/// It will give the most fitting art for the ``KodiItem``
///
/// For example, when asking for a season poster; you will get the ``Media/Artwork/seasonPoster``
public enum KodiArt {
    /// Just a placeholder
}


extension KodiArt {
    
    /// Get default art from the assets catalog
    struct Asset: View {
        init() { }
        var body: some View {
            Image("poster", bundle: Bundle.module)
                .resizable()
                .frame(width:300, height: 450)
        }
    }
}

public extension KodiArt {
    
    /// Poster of a ``KodiItem``
    struct Poster: View {
        let item: any KodiItem
        public init(item: any KodiItem) {
            self.item = item
        }
        public var body: some View {
            switch item {
            case let movie as Video.Details.Movie:
                Art(file: movie.poster)

            case let episode as Video.Details.Episode:
                Art(file: episode.art.seasonPoster)
            case let musicVideo as Video.Details.MusicVideo:
                Art(file: musicVideo.art.poster)
            case let artist as Audio.Details.Artist:
                Art(file: item.poster, fallback: "person")
            /// A Stream has no poster
            case _ as Audio.Details.Stream:
                Image(systemName: "dot.radiowaves.left.and.right")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            default:
                Art(file: item.poster)
            }
        }
    }
    
    /// Fanart of a ``KodiItem``
    ///
    /// - Note: For a ``Video/Details/Episode`` item it will be the ``Media/Artwork/thumb``
    struct Fanart: View {
        let item: any KodiItem
        public init(item: any KodiItem) {
            self.item = item
        }
        public var body: some View {
            switch item {
            case let movie as Video.Details.Movie:
                Art(file: movie.fanart)
//            case let tvshow as Video.Details.TVShow:
//                await VideoLibrary.setTVShowDetails(tvshow: tvshow)
            case let episode as Video.Details.Episode:
                Art(file: episode.art.thumb)
            case let musicVideo as Video.Details.MusicVideo:
                Art(file: musicVideo.art.fanart.isEmpty ? musicVideo.art.icon : musicVideo.art.fanart)
//                await VideoLibrary.setMusicVideoDetails(musicVideo: musicVideo)
//            case let song as Audio.Details.Song:
//                await AudioLibrary.setSongDetails(song: song)
            case let artist as Audio.Details.Artist:
                Art(file: artist.fanart, fallback: "person")
            default:
                Art(file: item.poster)
            }
        }
    }
    
    /// Any art passed as an internal Kodi string
    ///
    /// - Note:It will be converted to a 'full' url string
    struct Art: View {
        let file: String
        let fallback: String
        public init(file: String, fallback: String = "questionmark") {
            self.file = file
            self.fallback = fallback
        }
        public var body: some View {
            
            KFImage(URL(string: Files.getFullPath(file: file, type: .art))!)
            #if os(macOS)
                .onFailureImage(KFCrossPlatformImage(systemSymbolName: fallback, accessibilityDescription: "Image not found"))
            #endif
                .onFailure { e in
                    // e: KingfisherError
                    print("failure: \(e)")
                }
                .resizable()
                .aspectRatio(contentMode: .fit)
//            AsyncImage(
//                url: URL(string: Files.getFullPath(file: file, type: .art)),
//                transaction: Transaction(animation: .easeInOut(duration: 0.1))
//            ) { phase in
//                switch phase {
//                case .empty:
//                    ProgressView()
//                case .success(let image):
//                    image
//                        .resizable()
//                        .aspectRatio(contentMode: .fit)
//                        .transition(.opacity)
//                case .failure:
//                    //Image(systemName: "photo")
//                    Color.black
//                @unknown default:
//                    EmptyView()
//                }
//            }
        }
    }
}
