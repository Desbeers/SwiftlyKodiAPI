//
//  List+Item+File.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

public extension List.Item {

    /// File item (Global Kodi Type)
    struct File: Codable, Hashable {

        /// # List.Item.File

        /// The label of the file
        public var label: String
        /// The name of the file
        public var file: String
        /// The type of file
        public var fileType: FileType
        /// Optional last modified date
        public var lastModified: String?
        /// Optional last played date
        public var lastPlayed: String?
        /// Optional play count
        public var playCount: Int?
        /// Optional Watched Eposides, for `TV shows`
        public var watchedEpisodes: Int?
        /// The type of media
        public var type: Library.Media
        /// The optional Library ID
        public var id: Library.id?
        /// The calculated title based on the label
        public var title: String {
            label.components(separatedBy: ".").first ?? label
        }

        /// # Coding keys

        enum CodingKeys: String, CodingKey {
            case label
            case file
            case lastModified = "lastmodified"
            case lastPlayed = "lastplayed"
            case playCount = "playcount"
            case watchedEpisodes = "watchedepisodes"
            case fileType = "filetype"
            case type
            case id
        }
    }
}
