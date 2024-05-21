//
//  Video+Details+MovieSet+Extended.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Video.Details.MovieSet {

    /// Movies in a movie set (Global Kodi Type)
    /// - Note: Only used for 'VideoLibrary.GetMovieSetDetails'
    struct Extended: Codable, Identifiable, Hashable, Sendable {

        /// The ID of the movie
        public var id: Library.ID { movieID }
        /// The label of the movie
        public var label: String = ""
        /// The ID of the movie
        public var movieID: Library.ID = 0

        /// # Coding keys

        enum CodingKeys: String, CodingKey {
            case label
            case movieID = "movieid"
        }
    }
}
