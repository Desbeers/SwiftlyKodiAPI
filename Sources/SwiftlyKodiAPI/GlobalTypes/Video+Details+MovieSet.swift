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
        
        public var id: Int { setID }
        public var media: Library.Media = .movieSet
        public var file: String = ""
        public var lastPlayed: String = ""
        public var sortByTitle: String {
            /// Kodi has no sortTitle for sets
            title.removingPrefixes(["De", "The"])
        }
        public var poster: String { art.poster }
        
        /// # Video.Details.MovieSet
        
        public var plot: String = ""
        public var setID: Int = 0
        
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
