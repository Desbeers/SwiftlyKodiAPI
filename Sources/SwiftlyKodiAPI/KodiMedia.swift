//
//  KodiMedia.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

/// The Kodi media types
public enum KodiMedia: String, Equatable {
    /// None
    case none
    /// All items
    case all
    /// Movies
    case movie
    /// Movie sets
    case movieSet
    /// TV shows
    case tvshow
    /// Episodes
    case episode
    /// Music Videos
    case musicvideo
    /// Artists
    case artist
    /// The method for updating the media item
    var setDetailsMethod: KodiConnector.Method {
        switch self {
        case .movie:
            return .videoLibrarySetMovieDetails
        case .movieSet:
            return .videoLibrarySetMovieSetDetails
        case .tvshow:
            return .videoLibrarySetTVShowDetails
        case .episode:
            return .videoLibrarySetEpisodeDetails
        case .musicvideo:
            return .videoLibrarySetMusicVideoDetails
        default:
            return .videoLibraryGetMovies
        }
    }
}
