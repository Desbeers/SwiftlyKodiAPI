//
//  List+Sort+Option.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

extension List.Sort {

    // MARK: List.Sort.Option

    /// The sort options (SwiftlyKodi Type)
    public enum Option: String, CaseIterable {
        case title
        case year
        case duration
        case added
        case rating
        case genre
        case media

        var sorting: List.Sort {
            switch self {

            case .title:
                return List.Sort(method: .title, order: .ascending)
            case .year:
                return List.Sort(method: .year, order: .ascending)
            case .duration:
                return List.Sort(method: .duration, order: .ascending)
            case .added:
                return List.Sort(method: .dateAdded, order: .descending)
            case .rating:
                return List.Sort(method: .userRating, order: .descending)
            case .genre:
                return List.Sort(method: .genre, order: .ascending)
            case .media:
                return List.Sort(method: .media, order: .ascending)
            }
        }

        var label: String {
            switch self {

            case .title:
                return "Title"
            case .year:
                return "Year"
            case .duration:
                return "Duration"
            case .added:
                return "Added"
            case .rating:
                return "Rating"
            case .genre:
                return "Genre"
            case .media:
                return "Media"
            }
        }

        /// Get the sorting methods for a  ``KodiItem``
        /// - Parameter media: The kind of media
        /// - Returns: The available methods
        static public func getMethods(media: Library.Media) -> [Option] {
            switch media {
            case .movie:
                return [.title, .genre, .year, .duration, .added, .rating]
            case .tvshow:
                return [.title, .genre, .year]
            case .favorite:
                return [.title, .genre, .media]
            default:
                return []
            }
        }
    }
}
