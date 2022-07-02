//
//  Audio+Details+Base.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Audio.Details {
    
    struct Genres: Codable {
        public var genreID: Int = 0
        public var title: String = ""
        
        enum CodingKeys: String, CodingKey {
            case genreID = "genreid"
            case title
        }
    }
}
