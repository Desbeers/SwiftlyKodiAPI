//
//  List+Sort.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

extension List {

    /// The sort fields for JSON requests (SwiftlyKodi Type)
    public struct Sort: Codable {
        /// Init the sort order
        public init(method: List.Sort.Method = .title, order: List.Sort.Order = .ascending, useartistsortname: Bool = true) {
            self.method = method
            self.order = order
            self.useartistsortname = useartistsortname
        }
        /// The method
        public var method: Method
        /// The order
        public var order: Order
        /// Use artist sort name
        public var useartistsortname: Bool
        /// The sort method
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
            ///  Order by sort title
            case sortTitle = "sorttitle"
            ///  Order by tvshow title
            case tvshowTitle = "tvshowtitle"
            ///  Order by label
            case label = "label"
        }
        /// The sort order
        public enum Order: String, Codable {
            /// Order descending
            case descending
            /// Order ascending
            case ascending
        }
    }
}
