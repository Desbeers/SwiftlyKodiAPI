//
//  Video+Details+TVShow.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Video.Details {

    /// TV show details (Global Kodi Type)
    struct TVShow: KodiItem {

        /// # Public Init

        public init(
            /// Media have to be set; this to indentify the init
            media: Library.Media,
            resume: Video.Resume = Video.Resume(),
            cast: [Video.Cast] = [],
            episode: Int = 0,
            episodeGuide: String = "",
            genre: [String] = [],
            imdbNumber: String = "",
            mpaa: String = "",
            originalTitle: String = "",
            premiered: String = "",
            rating: Double = 0,
            ratings: Media.Ratings = Media.Ratings(),
            runtime: Int = 0,
            season: Int = 0,
            sortTitle: String = "",
            status: String? = nil,
            studio: [String] = [],
            tag: [String] = [],
            tvshowID: Library.ID = 0,
            userRating: Int = 0,
            votes: String = "",
            watchedEpisodes: Int = 0,
            year: Int = 0,
            dateAdded: String = "",
            file: String = "",
            lastPlayed: String = "",
            plot: String = "",
            title: String = "",
            art: Media.Artwork = Media.Artwork(),
            playcount: Int = 0,
            fanart: String = "",
            thumbnail: String = ""
        ) {
            self.media = media
            self.resume = resume
            self.cast = cast
            self.episode = episode
            self.episodeGuide = episodeGuide
            self.genre = genre
            self.imdbNumber = imdbNumber
            self.mpaa = mpaa
            self.originalTitle = originalTitle
            self.premiered = premiered
            self.rating = rating
            self.ratings = ratings
            self.runtime = runtime
            self.season = season
            self.sortTitle = sortTitle
            self.status = status
            self.studio = studio
            self.tag = tag
            self.tvshowID = tvshowID
            self.userRating = userRating
            self.votes = votes
            self.watchedEpisodes = watchedEpisodes
            self.year = year
            self.dateAdded = dateAdded
            self.file = file
            self.lastPlayed = lastPlayed
            self.plot = plot
            self.title = title
            self.art = art
            self.playcount = playcount
            self.fanart = fanart
            self.thumbnail = thumbnail
        }

        /// # Calculated variables

        /// The ID of the TV show
        public var id: String { "\(media)+\(tvshowID)" }
        /// The Kodi ID of the TV show
        public var kodiID: Library.ID { tvshowID }
        /// The type of media
        public var media: Library.Media = .tvshow
        /// Calculated sort title
        /// - Note: If `sortTitle` is set for the item it will be used, else the `title`
        public var sortByTitle: String { sortTitle.isEmpty ? title : sortTitle }
        /// The poster of the TV show
        public var poster: String { art.poster }
        /// The subtitle of the TV show
        public var subtitle: String { genre.joined(separator: " ∙ ") }
        /// The details of the TV show
        public var details: String { studio.joined(separator: " ∙ ") }
        public var description: String { plot }
        /// The duration of the TV show
        public var duration: Int { runtime }
        /// The resume position of the TV show
        /// - Note: Not in use but needed by protocol
        public var resume = Video.Resume()
        /// The search string
        public var search: String {
            "\(title)"
        }
        /// The stream details of the item
        /// - Note: Not in use but needed by protocol
        public var streamDetails = Video.Streams()

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
        public var tvshowID: Library.ID = 0
        // public var uniqueID: Int = 0
        public var userRating: Int = 0
        public var votes: String = ""
        public var watchedEpisodes: Int = 0
        public var year: Int = 0

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
            // case uniqueID = "uniqueid"
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
