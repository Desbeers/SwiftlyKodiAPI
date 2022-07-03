//
//  Audio+Album+Roles.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//
import Foundation

public extension Audio {
    
    /// All Audio details related items
    enum Artist {
        /// Just a placeholder
    }
}

public extension Audio.Artist {
    
    struct Roles: Codable {
        public var role: String = ""
        public var roleID: Int = 0
        
        enum CodingKeys: String, CodingKey {
            case role
            case roleID = "roleid"
        }
    }
}
