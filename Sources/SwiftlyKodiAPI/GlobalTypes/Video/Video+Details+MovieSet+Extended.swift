//
//  Video+Details+MovieSet+Extended.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

public extension Video.Details.MovieSet {

    /// Movies in a movie set
    /// - Note: Only used for 'VideoLibrary.GetMovieSetDetails'
    struct Extended: Codable, Identifiable, Hashable {

        /// The ID of the movie
        public var id: Library.id { movieID }
        /// The label of the movie
        public var label: String = ""
        /// The ID of the movie
        public var movieID: Library.id = 0

        /// # Coding keys

        enum CodingKeys: String, CodingKey {
            case label
            case movieID = "movieid"
        }
    }
}
