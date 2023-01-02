//
//  Video+Details+Movie.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

public extension Video.Details {

    /// Movie details
    struct Movie: KodiItem {

        /// # Calculated variables

        public var id: String { "\(media)+\(movieID)" }
        public var media: Library.Media = .movie
        public var sortByTitle: String { sortTitle.isEmpty ? title : sortTitle}
        public var poster: String { art.poster }
        public var subtitle: String { tagline.isEmpty ? year.description : tagline }
        public var details: String { genre.joined(separator: " ∙ ") }
        /// The search string
        public var search: String {
            "\(title)"
        }

        /// # Video.Details.Movie

        public var cast: [Video.Cast] = []
        public var country: [String] = []
        public var genre: [String] = []
        public var imdbNumber: String = ""
        public var movieID: Library.id = 0
        public var mpaa: String = ""
        public var originalTitle: String = ""
        public var plotOutline: String = ""
        public var premiered: String = ""
        public var rating: Double = 0
        public var ratings = Media.Ratings()
        public var set: String = ""
        public var setID: Int = 0
        public var showLink: [String] = []
        public var sortTitle: String = ""
        public var studio: [String] = []
        public var tag: [String] = []
        public var tagline: String = ""
        public var top250: Int = 0
        public var trailer: String = ""
        public var uniqueID: Int = 0
        public var userRating: Int = 0
        public var votes: String = ""
        public var writer: [String] = []
        public var year: Int = 0

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

        public var fanart: String = ""
        public var thumbnail: String = ""

        /// # Coding keys

        enum CodingKeys: String, CodingKey {
            case cast
            case country
            case genre
            case imdbNumber = "imdbnumber"
            case movieID = "movieid"
            case mpaa
            case originalTitle = "originaltitle"
            case plotOutline = "plotoutline"
            case premiered
            case rating
            case ratings
            case set
            case setID = "setid"
            case showLink = "showlink"
            case sortTitle = "sorttitle"
            case studio
            case tag
            case tagline
            case top250
            case trailer
            // case uniqueid
            case userRating = "userrating"
            case votes
            case writer
            case year
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
            case fanart
            case thumbnail
        }

    }
}
