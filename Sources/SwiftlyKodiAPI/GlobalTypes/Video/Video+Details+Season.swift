//
//  Video+Details+Season.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

public extension Video.Details {

    /// Season details (SwiftltKodi Type)
    ///
    /// Kodi does not have such item
    struct Season: KodiItem {

        /// # Public Init

        public init(
            tvshow: Video.Details.TVShow,
            season: Int,
            episodes: [Video.Details.Episode] = [],
            playcount: Int = 1,
            art: Media.Artwork = Media.Artwork()
        ) {
            self.tvshow = tvshow
            self.season = season
            self.episodes = episodes
            self.playcount = playcount
            self.art = art

            self.description = "All the seasons from \(tvshow.title)"
        }

        public var id: String {
            "\(title)-\(season)"
        }
        public var kodiID: Library.ID = 0
        public var media: Library.Media = .season
        public var title: String {
            switch season {
            case -1:
                return "TV Show info"
            case 0:
                return "Specials"
            default:
                return "Season \(season)"
            }
        }
        public var subtitle: String = ""
        public var details: String = ""
        public var description: String
        public var sortByTitle: String {
            title
        }
        public var dateAdded: String = ""
        public var year: Int = 0
        public var lastPlayed: String = ""
        public var rating: Double = 0
        public var userRating: Int = 0
        public var poster: String = ""

        public var fanart: String {
            tvshow.fanart
        }

        public var file: String = ""
        public var duration: Int = 0
        public var resume = Video.Resume()
        public var search: String = ""

        public var tvshow: Video.Details.TVShow
        public var season: Int
        public var episodes: [Video.Details.Episode]

        /// # Video.Details.Base

        public var art = Media.Artwork()
        public var playcount: Int = 1
    }
}
