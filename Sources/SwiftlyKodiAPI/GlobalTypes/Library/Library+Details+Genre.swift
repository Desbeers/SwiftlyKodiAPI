//
//  Library+Details.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Library.Details {

    /// Genre details (Global Kodi Type)
    struct Genre: KodiItem, Sendable {

        /// # Calculated variables

        /// The ID of the genre
        public var id: String { "\(media)+\(genreID)" }
        /// The Kodi ID of the genre
        public var kodiID: Library.ID { genreID }
        /// The type of media
        public var media: Library.Media = .genre
        /// The subtitle of the genre
        public var subtitle: String = ""
        /// The details of the genre
        public var details: String = ""
        public var duration: Int = 0
        public var description: String = ""
        /// The search string
        public var search: String {
            "\(title)"
        }

        /// Protocol requirements

        /// Calculated sort title
        public var sortByTitle: String { title }
        public var playcount: Int = 0
        public var lastPlayed: String = ""
        public var rating: Double = 0
        public var userRating: Int = 0
        /// The poster of the genre
        public var poster: String = ""
        public var fanart: String = ""
        /// The location of the media file
        public var file: String = ""
        /// The resume position of the genre
        /// - Note: Not in use but needed by protocol
        public var resume = Video.Resume()
        /// The date the genre is added
        /// - Note: Not in use but needed by protocol
        public var dateAdded: String = ""
        /// The release year of the item
        /// - Note: Not in use but needed by protocol
        public var year: Int = 0
        /// The genre of the item
        /// - Note: Not in use but needed by protocol
        public var genre: [String] = []

        /// # Library.Details.Genre

        public var genreID: Library.ID = 0
        // public var sourceID: [Int] = []
        public var thumbnail: String = ""
        public var title: String = ""

        /// # Codings keys

        enum CodingKeys: String, CodingKey {
            case genreID = "genreid"
            // case sourceID = "sourceid"
            case thumbnail
            case title
        }
    }
}
