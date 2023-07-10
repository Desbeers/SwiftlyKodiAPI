//
//  Library+Media.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import SwiftUI

public extension Library {

    /// Media types in the library (SwiftlyKodi Type)
    enum Media: String, Equatable, Codable, Sendable, CaseIterable {
        /// Not a media type
        case none
        /// Movies
        case movie
        /// Movie sets
        case movieSet = "movieset"
        /// TV shows
        case tvshow
        /// Seasons
        case season
        /// Episodes
        case episode
        /// Music Videos
        case musicVideo = "musicvideo"
        /// Music Video Album (SwiftlyKodi Type)
        case musicVideoAlbum
        /// Artists
        case artist
        /// Albums
        case album
        /// Songs
        case song
        /// Genres
        case genre
        /// Stream
        case stream
        /// Unknown
        case unknown

        public var description: String {
            switch self {
            case .movieSet:
                return "movie set"
            case .tvshow:
                return "TV show"
            case .musicVideo:
                return "music video"
            case .musicVideoAlbum:
                return "music video album"
            default:
                return self.rawValue
            }
        }

        @ViewBuilder var label: some View {
            switch self {
            case .movie:
                Label("Movie", systemImage: "film")
            case .movieSet:
                Label("Movie Set", systemImage: "circle.grid.cross.fill")
            case .musicVideo:
                Label("Music Video", systemImage: "music.note.tv")
            case .musicVideoAlbum:
                Label("Music Video Album", systemImage: "music.note.tv")
            case .tvshow:
                Label("TV show", systemImage: "tv")
            case .season:
                Label("Season", systemImage: "tv.inset.filled")
            case .episode:
                Label("Episode", systemImage: "tv.inset.filled")
            case .artist:
                Label("Artist", systemImage: "music.quarternote.3")
            default:
                Label("Unknown", systemImage: "questionmark")
            }
        }
    }
}
