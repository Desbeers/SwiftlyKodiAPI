//
//  Extensions.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Array where Element == KodiItem {
    
    /// Filter the movies to have only one movie representing a set
    /// - Returns: A list with movies without duplicated sets
    func uniqueSet() -> [KodiItem] {
        var knownSets = Set<Int>()
        return self.filter { element -> Bool in
            let set = element.setID
            if set == 0 || !knownSets.contains(set) {
                knownSets.insert(set)
                return true
            }
            /// This set is already in the list
            return false
        }
    }
}

extension Array where Element: Hashable {

    /// Remove duplicates from an Array
    /// - Returns: An new Array with unique elements
    public func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }
    
    /// Remove duplicates from an Array
    public mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

extension Array where Element == KodiItem {
    
    /// Standard sorting for movies; sets will be included in alphabetic order
    func sortBySetAndTitle() -> [KodiItem] {
        return self.sorted {
            $0.sortBySetAndTitle < $1.sortBySetAndTitle
        }
    }
    
    /// Sort first by year, than by title. Used insde moviesets and music videos from a specific artist
    func sortByYearAndTitle() -> [KodiItem] {
        return self.sorted {
            $0.releaseDate == $1.releaseDate ?
            $0.sortByTitle.localizedStandardCompare($1.sortByTitle) == .orderedAscending :
            $0.releaseDate < $1.releaseDate
        }
    }
}

extension Sequence {

    /// Filter a sequence by a certain tag
    /// - Returns: The filtered sequence
    public func unique<T: Hashable>(by taggingHandler: (_ element: Self.Iterator.Element) -> T) -> [Self.Iterator.Element] {
        var knownTags = Set<T>()
        return self.filter { element -> Bool in
            let tag = taggingHandler(element)
            if !knownTags.contains(tag) {
                knownTags.insert(tag)
                return true
            }
            return false
        }
    }
}
