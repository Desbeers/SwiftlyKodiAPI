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
            runtime: Int = 0,
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
            self.runtime = runtime
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
        public var description: String { plot }
        public var runtime: Int = 0
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
