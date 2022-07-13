//
//  Extensions.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import SwiftUI

// MARK: Music Video extensions

extension Array where Element == Video.Details.MusicVideo {
    
    /// Filter the music videos to have only one video representing an album
    /// - Returns: A list with music videos without duplicated albums
    public func uniqueAlbum() -> [Video.Details.MusicVideo] {
        var knownAlbums = Set<String>()
        return self.filter { element -> Bool in
            let album = element.album
            if album == "" || !knownAlbums.contains(album) {
                knownAlbums.insert(album)
                return true
            }
            /// This set is already in the list
            return false
        }
    }
}

// MARK: Array extensions

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
    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}

extension Array where Element: Hashable {
    func difference(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}

// MARK: Sequence extensions

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

extension String {
    func removingPrefixes(_ prefixes: [String]) -> String {
        let pattern = "^(\(prefixes.map{"\\Q"+$0+"\\E"}.joined(separator: "|")))\\s?"
        guard let range = self.range(of: pattern, options: [.regularExpression, .caseInsensitive]) else { return self }
        return String(self[range.upperBound...])
    }
}
