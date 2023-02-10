//
//  Video+Details+MovieSet.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

public extension Video.Details {

    /// Movie set details
    struct MovieSet: KodiItem {

        /// # Public Init

        public init(
            /// Media have to be set; this to indentify the init
            media: Library.Media,
            file: String = "",
            lastPlayed: String = "",
            subtitle: String = "",
            details: String = "",
            duration: Int = 0,
            userRating: Int = 0,
            resume: Video.Resume = Video.Resume(),
            plot: String = "",
            setID: Library.id = 0,
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
        /// The type of media
        public var media: Library.Media = .movieSet
        /// The location of the media file
        public var file: String = ""
        public var lastPlayed: String = ""
        /// Calculated sort title
        /// - Note: Kodi has no sortTitle for sets
        public var sortByTitle: String {
            title.removePrefixes(["De", "The"])
        }
        /// The poster of the movie set
        public var poster: String { art.poster }
        /// The subtitle of the movie set
        public var subtitle: String = ""
        /// The details of the movie set
        public var details: String = ""
        public var description: String { plot }
        public var duration: Int = 0
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
        /// The date the movieset is added
        /// - Note: Not in use but needed by protocol
        public var dateAdded: String = ""

        /// # Video.Details.MovieSet

        public var plot: String = ""
        public var setID: Library.id = 0

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
