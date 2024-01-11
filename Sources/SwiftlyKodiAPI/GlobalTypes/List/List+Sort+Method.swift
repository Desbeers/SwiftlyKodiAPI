//
//  List+Sort+Method.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

extension List.Sort {

    // MARK: List.Sort.Method

    /// The sort method (SwiftlyKodi Type)
    public enum Method: String, Codable, CaseIterable, Sendable {
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
        /// Order by genre
        case genre = "genre"
        /// Order by media
        case media = "media"

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
            case .genre:
                return "Sort by genre"
            case .media:
                return "Sort by media"
            default:
                return rawValue
            }
        }

        /// The label of the method (not complete)
        public var shortLabel: String {
            switch self {
            case .dateAdded:
                return "Added"
            case .year:
                return "Year"
            case .title:
                return "Title"
            case .duration:
                return "Duration"
            case .rating:
                return "Rating"
            case .userRating:
                return "Rating"
            case .genre:
                return "Genre"
            case .media:
                return "Media"
            default:
                return rawValue
            }
        }
    }
}
