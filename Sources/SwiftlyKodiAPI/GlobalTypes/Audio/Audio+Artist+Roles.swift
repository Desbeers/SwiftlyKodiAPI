//
//  Audio+Artist+Roles.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//
import Foundation

public extension Audio.Artist {

    /// The various roles contributed by an artist to one or more songs
    struct Roles: Codable, Identifiable, Equatable, Hashable {

        /// # Computed values

        public var id: Int { roleID }
        public var media: Library.Media = .artist

        /// # Audio.Artist.Roles

        public var role: String = ""
        public var roleID: Library.id = 0

        /// # Coding keys

        enum CodingKeys: String, CodingKey {
            case role
            case roleID = "roleid"
        }
    }
}
