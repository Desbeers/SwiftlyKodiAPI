//
//  Audio+Details+Genres.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

public extension Audio.Details {

    /// Genre details
    struct Genres: Codable, Identifiable, Equatable, Hashable, Sendable {

        /// # Computed values

        /// The ID of the genre
        public var id: Int { genreID }
        /// The type of media
        public var media: Library.Media = .genre

        /// # Audio.Details.Genres

        public var genreID: Library.ID = 0
        public var title: String = ""

        /// # Coding keys

        enum CodingKeys: String, CodingKey {
            case genreID = "genreid"
            case title
        }
    }
}
