//
//  List+Sort.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension List {
    /// The sort fields for JSON requests
    struct Sort: Codable {
        /// The method
        var method: Method = .title
        /// The order
        var order: Order = .ascending
        /// The sort methods
        enum Method: String, Codable {
            ///  Order by last played
            case lastPlayed = "lastplayed"
            ///  Order by play count
            case playcount = "playcount"
            ///  Order by year
            case year = "year"
            ///  Order by track
            case track = "track"
            ///  Order by artist
            case artist = "artist"
            ///  Order by title
            case title = "title"
            ///  Order by label
            case label = "label"
        }
        /// The sort orders
        enum Order: String, Codable {
            /// Order descending
            case descending
            /// Order ascending
            case ascending
        }
    }
}
