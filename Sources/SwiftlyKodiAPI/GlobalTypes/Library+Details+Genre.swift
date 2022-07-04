//
//  Library+Details.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Library.Details {
    
    /// Genre details
    struct Genre: LibraryItem {
        
        /// # Computed items
        
        public var id: Int { genreID }
        public var media: Library.Media = .genre
        
        /// # Library.Details.Genre
        
        public var genreID: Int = 0
        public var sourceID: [Int] = []
        public var thumbnail: String = ""
        public var title: String = ""
        
        /// # Codings keys
        
        enum CodingKeys: String, CodingKey {
            case genreID = "genreid"
            case sourceID = "sourceid"
            case thumbnail
            case title
        }
    }
}
