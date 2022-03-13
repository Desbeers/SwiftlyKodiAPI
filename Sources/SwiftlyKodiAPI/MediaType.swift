//
//  MediaType.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

/// All the media types from the Kodi library
///
/// - Note: This `Enum` is used when loading and filtering the library
public enum MediaType: String, Equatable, Codable {
    /// Not a media type
    case none
    /// All media types
    case all
    /// Movies
    case movie
    /// Movie sets
    case movieSet = "movieset"
    /// TV shows
    case tvshow
    /// Episodes
    case episode
    /// Music Videos
    case musicVideo = "musicvideo"
    /// Music Video Artists
    case musicVideoArtist
    /// Artists
    case artist
    /// Albums
    case album
    /// Songs
    case song
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
        case .musicVideo:
            return .videoLibrarySetMusicVideoDetails
        case .song:
            return .audioLibrarySetSongDetails
        default:
            /// This should not happen
            return .videoLibrarySetMovieDetails
        }
    }
}
