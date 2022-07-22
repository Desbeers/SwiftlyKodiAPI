//
//  Audio+Details.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Audio {
    
    /// The artist and the role they contribute to a song
    struct Contributors: Codable, Identifiable, Equatable, Hashable {
        
        /// Computed properties
        
        public var id: Int { artistID }
        
        public var artistID: Library.id = 0
        public var name: String = ""
        public var role: String = ""
        public var roleID: Library.id = 0
        /// Coding keys
        enum CodingKeys: String, CodingKey {
            case artistID = "artistid"
            case name
            case role
            case roleID = "roleid"
        }
    }
}
