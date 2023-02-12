//
//  KodiItem+Sorting.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

extension List.Sort {

    static public func getMethods(media: Library.Media) -> [Method] {
        switch media {
        case .movie:
            return [.title, .year, .duration, .dateAdded, .rating, .userRating]
        default:
            return []
        }
    }
}

extension Array where Element == any KodiItem {

    /// Sort an Array of any KodiItem's
    /// - Parameter sortItem: The sorting
    /// - Returns: A sorted Array
    public func sorted(sortItem: List.Sort) -> Array {
        switch sortItem.method {
        case .title:
            return self.sorted(using: KeyPathComparator(\.sortByTitle, order: sortItem.order.value))
        case .duration:
            return self.sorted(using: KeyPathComparator(\.duration, order: sortItem.order.value))
        case .dateAdded:
            return self.sorted(using: KeyPathComparator(\.dateAdded, order: sortItem.order.value))
        case .year:
            return self.sorted(using: [
                KeyPathComparator(\.year, order: sortItem.order.value),
                KeyPathComparator(\.title, order: .forward)
            ])
        case .rating:
            return self.sorted(using: [
                KeyPathComparator(\.rating, order: sortItem.order.value),
                KeyPathComparator(\.title, order: .forward)
            ])
        case .userRating:
            return self.sorted(using: [
                KeyPathComparator(\.userRating, order: sortItem.order.value),
                KeyPathComparator(\.title, order: .forward)
            ])
        default:
            return self
        }
    }
}

extension Array where Element: KodiItem {

    /// Sort an Array of KodiItem's of a specific type
    /// - Parameter sortItem: The sorting
    /// - Returns: A sorted Array
    public func sorted(sortItem: List.Sort) -> Array {
        switch sortItem.method {
        case .title:
            return self.sorted(using: KeyPathComparator(\.sortByTitle, order: sortItem.order.value))
        case .duration:
            return self.sorted(using: KeyPathComparator(\.duration, order: sortItem.order.value))
        case .dateAdded:
            return self.sorted(using: KeyPathComparator(\.dateAdded, order: sortItem.order.value))
        case .year:
            return self.sorted(using: [
                KeyPathComparator(\.year, order: sortItem.order.value),
                KeyPathComparator(\.title, order: .forward)
            ])
        default:
            return self
        }
    }
}
