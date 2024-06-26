//
//  Audio+Property+Value.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Audio.Property {

    /// Values for audio properties (Global Kodi Type)
    struct Value: Codable, Equatable, Sendable {
        public var albumsLastAdded: String = ""
        public var albumsModified: String = ""
        public var artistLinksUpdated: String = ""
        public var artistsLastAdded: String = ""
        public var artistsModified: String = ""
        public var genresLastAdded: String = ""
        public var libraryLastCleaned: String = ""
        // public var libraryLastUpdated: String = ""
        public var missingArtistID: Library.ID = -1
        public var songsLastAdded: String = ""
        public var songsModified: String = ""
        /// Coding keys
        enum CodingKeys: String, CodingKey {
            case albumsLastAdded = "albumslastadded"
            case albumsModified = "albumsmodified"
            case artistLinksUpdated = "artistlinksupdated"
            case artistsLastAdded = "artistslastadded"
            case artistsModified = "artistsmodified"
            case genresLastAdded = "genreslastadded"
            case libraryLastCleaned = "librarylastcleaned"
            // case libraryLastUpdated = "librarylastupdated"
            case missingArtistID = "missingartistid"
            case songsLastAdded = "songslastadded"
            case songsModified = "songsmodified"
        }
    }
}
