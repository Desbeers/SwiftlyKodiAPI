//
//  KodiItem+Sorting.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

// MARK: Return a sorted Array

extension Array where Element == any KodiItem {

    /// Sort an Array of KodiItem's
    /// - Parameter sortItem: The sorting
    /// - Returns: A sorted Array
    public func sorted(sortItem: List.Sort) -> Array {
        let sorting = List.Sort.buildKeyPathComparator(sortItem: sortItem)
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
        let sorting = List.Sort.buildKeyPathComparator(sortItem: sortItem)
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
