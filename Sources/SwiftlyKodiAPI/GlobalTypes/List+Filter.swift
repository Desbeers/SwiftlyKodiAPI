//
//  List+Filter.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension List {
    
    /// Filter fields for JSON requests (SwiftlyKodi Type)
    public struct Filter: Codable {
        /// Filter by album ID
        var albumID: Library.id?
        /// Filter by artist ID
        var artistID: Library.id?
        /// Coding keys
        enum CodingKeys: String, CodingKey {
            case albumID = "albumid"
            case artistID = "artistid"
        }
    }
}
