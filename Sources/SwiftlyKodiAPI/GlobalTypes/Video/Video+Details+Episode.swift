//
//  Video+Details+Episode.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

public extension Video.Details {

    /// Episode details
    struct Episode: KodiItem {

        /// # Calculated variables

        public var id: String { "\(media)+\(episodeID)" }
        public var media: Library.Media = .episode
        public var sortByTitle: String { title }
        public var poster: String { thumbnail }
        public var fanart: String {
            art.thumb
        }
        public var subtitle: String { showTitle }
        public var details: String { "Season \(season), episode \(episode)" }
        /// The search string
        public var search: String {
            "\(title) \(showTitle)"
        }

        /// # Video.Details.Episode

        public var cast: [Video.Cast] = []
        public var episode: Int = 0
        public var episodeID: Library.id = 0
        public var firstAired: String = ""
        public var originalTitle: String = ""
        public var productionCode: String = ""
        public var rating: Double = 0
        public var ratings = Media.Ratings()
        public var season: Int = 0
        public var seasonID: Library.id = 0
        public var showTitle: String = ""
        public var specialSortEpisode: Int = 0
        public var specialSortSeason: Int = 0
        public var tvshowID: Library.id = 0
        public var uniqueID: Int = 0
        public var userRating: Int = 0
        public var votes: String = ""
        public var writer: [String] = []

        /// # Video.Details.File

        public var director: [String] = []
        public var resume = Video.Resume()
        public var runtime: Int = 0
        public var streamDetails = Video.Streams()

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

        public var thumbnail: String = ""

        /// # Coding keys

        enum CodingKeys: String, CodingKey {
            case cast
            case episode
            case episodeID = "episodeid"
            case firstAired = "firstaired"
            case originalTitle = "originaltitle"
            case productionCode = "productioncode"
            case rating
            case ratings
            case season
            case seasonID = "seasonid"
            case showTitle = "showtitle"
            case specialSortEpisode = "specialsortepisode"
            case specialSortSeason = "specialsortseason"
            case tvshowID = "tvshowid"
            // case uniqueID = "uniqueid"
            case userRating = "userrating"
            case votes
            case writer
            case director
            case resume
            case runtime
            case streamDetails = "streamdetails"
            case dateAdded = "dateadded"
            case file
            case lastPlayed = "lastplayed"
            case plot
            case title
            case art
            case playcount
            // case fanart
            case thumbnail
        }
    }
}
