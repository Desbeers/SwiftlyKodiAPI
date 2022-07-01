//
//  List+Sort.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension List {
    /// The sort fields for JSON requests
    public struct Sort: Codable {
        /// Default sort order
        public init(method: List.Sort.Method = .title, order: List.Sort.Order = .ascending) {
            self.method = method
            self.order = order
        }
        /// The method
        public var method: Method
        /// The order
        public var order: Order
        /// The sort methods
        public enum Method: String, Codable {
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
        public enum Order: String, Codable {
            /// Order descending
            case descending
            /// Order ascending
            case ascending
        }
    }
}