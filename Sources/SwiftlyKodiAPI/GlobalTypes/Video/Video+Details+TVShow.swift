//
//  Video+Details+TVShow.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Video.Details {
    
    /// TV show details
    struct TVShow: KodiItem {
        
        /// # Calculated variables
        
        public var id: Int { tvshowID }
        public var media: Library.Media = .tvshow
        public var sortByTitle: String { sortTitle.isEmpty ? title: sortTitle}
        public var poster: String { art.poster }
        public var subtitle: String = ""
        public var details: String { studio.joined(separator: " ∙ ") }
        
        /// The search string
        public var search: String {
            "\(title)"
        }
        
        /// # Video.Details.TVShow
        
        public var cast: [Video.Cast] = []
        public var episode: Int = 0
        public var episodeGuide: String = ""
        public var genre: [String] = []
        public var imdbNumber: String = ""
        public var mpaa: String = ""
        public var originalTitle: String = ""
        public var premiered: String = ""
        public var rating: Double = 0
        public var ratings = Media.Ratings()
        public var runtime: Int = 0
        public var season: Int = 0
        public var sortTitle: String = ""
        public var status: String? /// BUG: This always returns nil
        public var studio: [String] = []
        public var tag: [String] = []
        public var tvshowID: Library.id = 0
        //public var uniqueID: Int = 0
        public var userRating: Int = 0
        public var votes: String = ""
        public var watchedEpisodes: Int = 0
        public var year: Int = 0
        
        /// # Video.Details.Item
        
        public var dateAdded: String = ""
        public var file: String = ""
        public var lastPlayed: String = ""
        public var plot: String = ""
        
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
            case cast
            case episode
            case episodeGuide = "episodeguide"
            case genre
            case imdbNumber = "imdbnumber"
            case mpaa
            case originalTitle = "originaltitle"
            case premiered
            case rating
            case ratings
            case runtime
            case season
            case sortTitle = "sorttitle"
            case status
            case studio
            case tag
            case tvshowID = "tvshowid"
            //case uniqueID = "uniqueid"
            case userRating = "userrating"
            case votes
            case watchedEpisodes = "watchedepisodes"
            case year
            case dateAdded = "dateadded"
            case file
            case lastPlayed = "lastplayed"
            case plot
            case title
            case art
            case playcount
            case fanart
            case thumbnail
        }
    }
}
