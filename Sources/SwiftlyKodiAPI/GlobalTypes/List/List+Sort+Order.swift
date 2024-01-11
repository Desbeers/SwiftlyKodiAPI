//
//  List+Sort+Order.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

extension List.Sort {

    // MARK: List.Sort.Order

    /// The sort order (SwiftlyKodi Type)
    public enum Order: String, Codable, CaseIterable, Sendable {
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
