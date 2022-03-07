//
//  MediaType.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

/// All the media types
///
/// - Note: This `Enum` is used when loading and filtering the library
public enum MediaType: String, Equatable {
    /// Not a media type
    case none
    /// All media types
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
    /// Music Video Artists
    case musicVideoArtist
    /// Artists
    case artist
    /// Genres
    case genre
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
            /// This should not happen
            return .videoLibrarySetMovieDetails
        }
    }
}