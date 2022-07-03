//
//  Library+Details.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Library.Details {
    
    /// Genre details
    struct Genre: Codable, Identifiable {
        
        public var id: Int { genreID }
        
        public var genreID: Int = 0
        public var sourceID: [Int] = []
        public var thumbnail: String = ""
        public var title: String = ""
        
        enum CodingKeys: String, CodingKey {
            case genreID = "genreid"
            case sourceID = "sourceid"
            case thumbnail
            case title
        }
    }
}
