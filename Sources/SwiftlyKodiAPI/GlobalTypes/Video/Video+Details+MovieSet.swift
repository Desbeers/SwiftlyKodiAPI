//
//  Video+Details+MovieSet.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Video.Details {

    /// Movie set details (Global Kodi Type)
    struct MovieSet: KodiItem {

        /// # Public Init

        public init(
            /// Media have to be set; this to identify the init
            media: Library.Media,
            file: String = "",
            lastPlayed: String = "",
            subtitle: String = "",
            details: String = "",
            duration: Int = 0,
            userRating: Int = 0,
            resume: Video.Resume = Video.Resume(),
            plot: String = "",
            setID: Library.ID = 0,
            movies: [Video.Details.MovieSet.Extended]? = nil,
            title: String = "",
            art: Media.Artwork = Media.Artwork(),
            playcount: Int = 0,
            fanart: String = "",
            thumbnail: String = ""
        ) {
            self.media = media
            self.file = file
            self.lastPlayed = lastPlayed
            self.subtitle = subtitle
            self.details = details
            self.duration = duration
            self.userRating = userRating
            self.resume = resume
            self.plot = plot
            self.setID = setID
            self.movies = movies
            self.title = title
            self.art = art
            self.playcount = playcount
            self.fanart = fanart
            self.thumbnail = thumbnail
        }

        /// # Calculated variables

        /// The ID of the movie set
        public var id: String { "\(media)+\(setID)" }
        /// The Kodi ID of the movie set
        public var kodiID: Library.ID { setID }
        /// The type of media
        public var media: Library.Media = .movieSet
        /// The location of the media file
        public var file: String = ""
        public var lastPlayed: String = ""
        /// Calculated sort title
        /// - Note: Kodi has no sortTitle for sets
        public var sortByTitle: String {
            title.removePrefixes(["De", "The", "A"])
        }
        /// The poster of the movie set
        public var poster: String { art.poster }
        /// The subtitle of the movie set
        public var subtitle: String = "Movie Set"
        /// The details of the movie set
        public var details: String = ""
        public var description: String { plot }
        public var duration: Int = 0
        public var rating: Double = 0
        public var userRating: Int = 0
        /// The resume position of the movie set
        /// - Note: Not in use but needed by protocol
        public var resume = Video.Resume()
        /// The search string
        public var search: String {
            "\(title)"
        }
        /// The release year of the item
        /// - Note: Not in use but needed by protocol
        public var year: Int = 0
        /// The genre of the item
        /// - Note: Not in use but needed by protocol
        public var genre: [String] = []
        /// The date the movieset is added
        /// - Note: Not in use but needed by protocol
        public var dateAdded: String = ""
        /// The stream details of the item
        /// - Note: Not in use but needed by protocol
        public var streamDetails = Video.Streams()
        /// The country of the item
        public var country: [String] = []

        /// # Video.Details.MovieSet

        public var plot: String = ""
        public var setID: Library.ID = 0

        /// # Video.Details.MovieSet.Extended (optional)

        public var movies: [Extended]?

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
            case movies
        }
    }
}
