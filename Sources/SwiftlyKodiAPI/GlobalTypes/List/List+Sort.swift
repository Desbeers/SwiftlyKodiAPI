//
//  List+Sort.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

extension List {

    /// The sort fields for JSON requests (Global Kodi Type)
    public struct Sort: Codable, Equatable {
        /// Init the sort order
        public init(id: String = "ID", method: List.Sort.Method = .title, order: List.Sort.Order = .ascending, useartistsortname: Bool = true) {
            self.id = id
            self.method = method
            self.order = order
            self.useartistsortname = useartistsortname
        }
        /// The ID of the sort
        /// - Note: Not in use for KodiAPI but for internal sorting of ``KodiItem``s
        public var id: String
        /// The method
        public var method: Method
        /// The order
        public var order: Order
        /// Use artist sort name
        public var useartistsortname: Bool
        /// The sort method
        public enum Method: String, Codable, CaseIterable {
            /// Order by date added
            case dateAdded = "dateadded"
            /// Order by last played
            case lastPlayed = "lastplayed"
            /// Order by play count
            case playcount = "playcount"
            /// Order by year
            case year = "year"
            /// Order by track
            case track = "track"
            /// Order by artist
            case artist = "artist"
            /// Order by title
            case title = "title"
            /// Order by sort title
            case sortTitle = "sorttitle"
            /// Order by tvshow title
            case tvshowTitle = "tvshowtitle"
            /// Order by label
            case label = "label"
            /// Order by duration (Called 'time' in Kodi)
            case duration = "time"
            /// Order by rating
            case rating = "rating"
            /// Order by user rating
            case userRating = "userrating"

            /// The label of the method (not complete)
            public var displayLabel: String {
                switch self {
                case .dateAdded:
                    return "Sort by date added"
                case .year:
                    return "Sort by year"
                case .title:
                    return "Sort by title"
                case .duration:
                    return "Sort by duration"
                case .rating:
                    return "Sort by system rating"
                case .userRating:
                    return "Sort by your rating"
                default:
                    return rawValue
                }
            }
        }
        /// The sort order
        public enum Order: String, Codable, CaseIterable {
            /// Order ascending
            case ascending
            /// Order descending
            case descending
            /// The `SortOrder` value
            public var value: SortOrder {
                switch self {
                case .ascending:
                    return .forward
                case .descending:
                    return .reverse
                }
            }
            /// Label for the sort order
            /// - Parameter method: The sort method
            /// - Returns: A String with the appropriate label
            public func displayLabel(method: List.Sort.Method) -> String {
                switch self {
                case .ascending:
                    switch method {
                    case .title:
                        return "A - Z"
                    case .duration:
                        return "Shortest first"
                    case .dateAdded, .year:
                        return "Oldest first"
                    case .rating, .userRating:
                        return "Lowest first"
                    default:
                        return rawValue
                    }
                case .descending:
                    switch method {
                    case .title:
                        return "Z - A"
                    case .duration:
                        return "Longest first"
                    case .dateAdded, .year:
                        return "Newest first"
                    case .rating, .userRating:
                        return "Highest first"
                    default:
                        return rawValue
                    }
                }
            }
        }
    }
}
