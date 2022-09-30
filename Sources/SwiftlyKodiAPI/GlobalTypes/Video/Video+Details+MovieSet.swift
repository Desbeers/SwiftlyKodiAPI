//
//  Video+Details+MovieSet.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Video.Details {
    
    /// Movie set details
    struct MovieSet: KodiItem {
        
        /// # Calculated variables
        
        public var id: String { "\(media)+\(setID)" }
        public var media: Library.Media = .movieSet
        public var file: String = ""
        public var lastPlayed: String = ""
        public var sortByTitle: String {
            /// Kodi has no sortTitle for sets
            title.removePrefixes(["De", "The"])
        }
        public var poster: String { art.poster }
        
        public var subtitle: String = ""
        public var details: String = ""
        
        
        public var userRating: Int = 0
        
        /// Not in use but needed by protocol
        public var resume = Video.Resume()
        
        /// The search string
        public var search: String {
            "\(title)"
        }
        
        /// # Video.Details.MovieSet
        
        public var plot: String = ""
        public var setID: Library.id = 0
        
        /// # Video.Details.Media
        
        public var title: String = ""
        
        /// # Video.Details.Base
        
        public var art = Media.Artwork()
        public var playcount: Int = 0
        
        
        /// # Media.Details.Base
        
        public var fanart: String = ""
        public var thumbnail: String = ""
        
        
        /// # Coding keys
        
        enum CodingKeys: String, CodingKey {
            case plot
            case setID = "setid"
            case title
            case art
            case playcount
            case fanart
            case thumbnail
        }

    }
}

public extension Audio.Details.Album {

}
