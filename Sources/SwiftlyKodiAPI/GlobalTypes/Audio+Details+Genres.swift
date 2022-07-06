//
//  Audio+Details+Base.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Audio.Details {
    
    /// Genre details
    struct Genres: Codable, Identifiable, Equatable {
        
        /// # Computed values
        
        public var id: Int { genreID }
        public var media: Library.Media = .genre
        
        public var genreID: Int = 0
        public var title: String = ""
        
        enum CodingKeys: String, CodingKey {
            case genreID = "genreid"
            case title
        }
    }
}
