//
//  MediaButtons.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import SwiftUI


/// SwiftUI Views for Kodi art
public enum KodiArt {
    /// Just a placeholder
}

public extension KodiArt {
    /// Poster art of a ``KodiItem``
    struct Poster: View {
        let item: any KodiItem
        public init(item: any KodiItem) {
            self.item = item
        }
        public var body: some View {
            switch item {
            case let movie as Video.Details.Movie:
                Art(file: movie.poster)
//            case let tvshow as Video.Details.TVShow:
//                await VideoLibrary.setTVShowDetails(tvshow: tvshow)
            case let episode as Video.Details.Episode:
                Art(file: episode.art.seasonPoster)
//            case let musicVideo as Video.Details.MusicVideo:
//                await VideoLibrary.setMusicVideoDetails(musicVideo: musicVideo)
//            case let song as Audio.Details.Song:
//                await AudioLibrary.setSongDetails(song: song)
            default:
                Art(file: item.poster)
            }
        }
    }
    
    /// Fanart art of a ``KodiItem``
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
                Art(file: episode.thumbnail)
//            case let musicVideo as Video.Details.MusicVideo:
//                await VideoLibrary.setMusicVideoDetails(musicVideo: musicVideo)
//            case let song as Audio.Details.Song:
//                await AudioLibrary.setSongDetails(song: song)
            default:
                Art(file: item.poster)
            }
        }
    }
    
    struct Art: View {
        let file: String
        public init(file: String) {
            self.file = file
        }
        public var body: some View {
            AsyncImage(url: URL(string: Files.getFullPath(file: file, type: .art))) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } placeholder: {
                Color.black
            }
        }
    }
}
