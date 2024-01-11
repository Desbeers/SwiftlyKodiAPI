//
//  Video+Details+Episode.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Video.Details {

    /// Episode details
    struct Episode: KodiItem {

        /// # Calculated variables

        /// The ID of the episode
        public var id: String { "\(media)+\(episodeID)" }
        /// The Kodi ID of the episode
        public var kodiID: Library.ID { episodeID }
        /// The type of media
        public var media: Library.Media = .episode
        /// Calculated sort title
        public var sortByTitle: String { title }
        /// The poster of the episode
        public var poster: String { thumbnail }
        public var fanart: String {
            art.thumb
        }
        /// The subtitle of the TV show
        public var subtitle: String { showTitle }
        /// The details of the TV show
        public var details: String {
            return (season == 0 ? "Specials" : "Season \(season)") + ", episode \(episode)"
        }
        public var description: String { plot }
        /// The duration of the episode
        public var duration: Int { runtime }
        /// The search string
        public var search: String {
            "\(title) \(showTitle)"
        }
        /// The release year of the item
        /// - Note: Not in use but needed by protocol
        public var year: Int = 0
        /// The genre of the item
        /// - Note: Not in use but needed by protocol
        public var genre: [String] = []

        /// # Video.Details.Episode

        public var cast: [Video.Cast] = []
        public var episode: Int = 0
        public var episodeID: Library.ID = 0
        public var firstAired: String = ""
        public var originalTitle: String = ""
        public var productionCode: String = ""
        public var rating: Double = 0
        public var ratings = Media.Ratings()
        public var season: Int = 0
        public var seasonID: Library.ID = 0
        public var showTitle: String = ""
        public var specialSortEpisode: Int = 0
        public var specialSortSeason: Int = 0
        public var tvshowID: Library.ID = 0
        public var uniqueID: Int = 0
        public var userRating: Int = 0
        public var votes: String = ""
        public var writer: [String] = []

        /// # Video.Details.File

        public var director: [String] = []
        /// The resume position of the episode
        public var resume = Video.Resume()
        public var runtime: Int = 0
        public var streamDetails = Video.Streams()

        /// # Video.Details.Item

        public var dateAdded: String = ""
        /// The location of the media file
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
