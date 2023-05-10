//
//  KodiItem+Sorting.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

extension List.Sort {

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

/// Build the sorting method and order for a ``KodiItem`` array
/// - Parameter sortItem: The sorting
/// - Returns: An array with `KeyPathComparator`
public func buildKeyPathComparator(sortItem: List.Sort) -> [KeyPathComparator<any KodiItem>] {
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
    default:
        return [ KeyPathComparator(\.sortByTitle, order: sortItem.order.value) ]
    }
}

// MARK: Return a sorted Array

extension Array where Element == any KodiItem {

    /// Sort an Array of KodiItem's
    /// - Parameter sortItem: The sorting
    /// - Returns: A sorted Array
    public func sorted(sortItem: List.Sort) -> Array {
        let sorting = buildKeyPathComparator(sortItem: sortItem)
        return self.sorted(using: sorting)
    }
}

extension Array where Element: KodiItem {

    /// Sort an Array of KodiItem's of a specific type
    /// - Parameter sortItem: The sorting
    /// - Returns: A sorted Array
    public func sorted(sortItem: List.Sort) -> Array {
        let items = self as [any KodiItem]
        return items.sorted(sortItem: sortItem)  as? [Element] ?? []
    }
}

// MARK: Sort in place

extension Array where Element == any KodiItem {

    /// Sort an Array of KodiItem's
    /// - Parameter sortItem: The sorting
    /// - Returns: A sorted Array
    public mutating func sort(sortItem: List.Sort) {
        let sorting = buildKeyPathComparator(sortItem: sortItem)
        self.sort(using: sorting)
    }
}

extension Array where Element: KodiItem {

    /// Sort an Array of KodiItem's of a specific type
    /// - Parameter sortItem: The sorting
    /// - Returns: A sorted Array
    public mutating func sort(sortItem: List.Sort) {
        var items = self as [any KodiItem]
        items.sort(sortItem: sortItem)
        self = items as? [Element] ?? []
    }
}
