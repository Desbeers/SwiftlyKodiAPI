//
//  Audio+Artist+Roles.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//
import Foundation

public extension Audio.Artist {
    
    /// The various roles contributed by an artist to one or more songs
    struct Roles: Codable, Identifiable, Equatable {
        
        /// # Computed values
        
        public var id: Int { roleID }
        public var media: Library.Media = .artist
        
        public var role: String = ""
        public var roleID: Int = 0
        
        enum CodingKeys: String, CodingKey {
            case role
            case roleID = "roleid"
        }
    }
}
