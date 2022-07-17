//
//  Library.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

/// All Library related items
public struct Library {
    /// Just a placeholder
}

public extension Library {
    
    /// All the media types from the Kodi library
    enum Media: String, Equatable, Codable {
        /// Not a media type
        case none
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
    }
}
