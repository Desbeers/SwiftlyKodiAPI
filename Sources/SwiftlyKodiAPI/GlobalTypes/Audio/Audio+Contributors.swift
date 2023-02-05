//
//  Audio+Details.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

public extension Audio {

    /// The artist and the role they contribute to a song (Global Kodi Type)
    struct Contributors: Codable, Identifiable, Equatable, Hashable {

        /// # Computed values

        /// The ID of the contributor
        public var id: Int { artistID }

        /// # Audio.Contributors

        /// The ID of the artist
        public var artistID: Library.id = 0
        /// The name of the artist
        public var name: String = ""
        /// The role of the artist
        public var role: String = ""
        /// The ID of the role
        public var roleID: Library.id = 0

        /// # Coding keys

        /// Coding keys
        enum CodingKeys: String, CodingKey {
            case artistID = "artistid"
            case name
            case role
            case roleID = "roleid"
        }
    }
}
