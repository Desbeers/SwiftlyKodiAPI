//
//  Audio+Artist+Roles.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//
import Foundation

public extension Audio.Artist {

    /// The various roles contributed by an artist to one or more songs (Global Kodi Type)
    struct Roles: Codable, Identifiable, Equatable, Hashable {

        /// # Computed values

        /// The ID of the role
        public var id: Int { roleID }
        /// The type of media
        public var media: Library.Media = .artist

        /// # Audio.Artist.Roles

        /// The role of the artist
        public var role: String = ""
        /// The ID of the role
        public var roleID: Library.id = 0

        /// # Coding keys

        /// Coding keys
        enum CodingKeys: String, CodingKey {
            case role
            case roleID = "roleid"
        }
    }
}
