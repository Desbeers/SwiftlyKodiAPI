//
//  List+Sort+Extensions.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

extension List.Sort {

    // MARK: List.Sort.getMethods

    /// Get the sorting methods for a  ``KodiItem``
    /// - Parameter media: The kind of media
    /// - Returns: The available methods
    static public func getMethods(media: Library.Media) -> [Method] {
        switch media {
        case .movie:
            return [.title, .year, .duration, .dateAdded, .rating, .userRating]
        case .song:
            return [.title, .artist, .dateAdded, .lastPlayed, .playcount, .userRating]
        default:
            return []
        }
    }
}

extension List.Sort {

    // MARK: List.Sort.buildKeyPathComparator

    /// Build the sorting method and order for a ``KodiItem`` array
    /// - Parameter sortItem: The sorting
    /// - Returns: An array with `KeyPathComparator`
    public static func buildKeyPathComparator(sortItem: List.Sort) -> [KeyPathComparator<any KodiItem>] {
        switch sortItem.method {
        case .title:
            return [ KeyPathComparator(\.sortByTitle, order: sortItem.order.value) ]
        case .duration:
            return [ KeyPathComparator(\.duration, order: sortItem.order.value) ]
        case .dateAdded:
            return [ KeyPathComparator(\.dateAdded, order: sortItem.order.value) ]
        case .year:
            return [
                KeyPathComparator(\.year, order: sortItem.order.value),
                KeyPathComparator(\.sortByTitle, order: .forward)
            ]
        case .rating:
            return [
                KeyPathComparator(\.rating, order: sortItem.order.value),
                KeyPathComparator(\.sortByTitle, order: .forward)
            ]
        case .lastPlayed:
            return [
                KeyPathComparator(\.lastPlayed, order: sortItem.order.value),
                KeyPathComparator(\.sortByTitle, order: .forward)
            ]
        case .userRating:
            return [
                KeyPathComparator(\.userRating, order: sortItem.order.value),
                KeyPathComparator(\.sortByTitle, order: .forward)
            ]
        case .playcount:
            return [
                KeyPathComparator(\.playcount, order: sortItem.order.value),
                KeyPathComparator(\.sortByTitle, order: .forward)
            ]
        case .artist:
            return [
                KeyPathComparator(\.subtitle, order: sortItem.order.value),
                KeyPathComparator(\.sortByTitle, order: .forward)
            ]
        case .media:
            return [
                KeyPathComparator(\.media.rawValue, order: sortItem.order.value),
                KeyPathComparator(\.sortByTitle, order: .forward)
            ]
        default:
            return [ KeyPathComparator(\.sortByTitle, order: sortItem.order.value) ]
        }
    }
}
