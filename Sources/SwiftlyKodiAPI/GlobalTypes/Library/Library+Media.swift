//
//  Library+Media.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

public extension Library {

    /// Media types in the library (SwiftlyKodi Type)
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
