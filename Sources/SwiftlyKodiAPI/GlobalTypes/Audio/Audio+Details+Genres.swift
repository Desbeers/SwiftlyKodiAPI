//
//  Audio+Details+Genres.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Audio.Details {
    
    /// Genre details
    struct Genres: Codable, Identifiable, Equatable, Hashable {
        
        /// # Computed values
        
        public var id: Int { genreID }
        public var media: Library.Media = .genre
        
        /// # Audio.Details.Genres
        
        public var genreID: Library.id = 0
        public var title: String = ""
        
        /// # Coding keys
        
        enum CodingKeys: String, CodingKey {
            case genreID = "genreid"
            case title
        }
    }
}
