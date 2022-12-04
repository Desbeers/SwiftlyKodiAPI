//
//  Library+Details.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Library.Details {
    
    /// Genre details
    struct Genre: KodiItem {

        /// # Computed values
        
        public var id: String { "\(media)+\(genreID)" }
        public var media: Library.Media = .genre
        public var subtitle: String = ""
        public var details: String = ""
        public var runtime: Int = 0
        /// The search string
        public var search: String {
            "\(title)"
        }

        /// Protocol requirements
        
        public var sortByTitle: String { title }
        public var playcount: Int = 0
        public var lastPlayed: String = ""
        public var userRating: Int = 0
        public var poster: String = ""
        public var fanart: String = ""
        public var file: String = ""
        public var resume = Video.Resume()
        
        /// # Library.Details.Genre
        
        public var genreID: Library.id = 0
        //public var sourceID: [Int] = []
        public var thumbnail: String = ""
        public var title: String = ""
        
        /// # Codings keys
        
        enum CodingKeys: String, CodingKey {
            case genreID = "genreid"
            // case sourceID = "sourceid"
            case thumbnail
            case title
        }
    }
}
