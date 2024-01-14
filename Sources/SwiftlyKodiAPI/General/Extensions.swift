//
//  Extensions.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import SwiftUI

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
    func arrayDiff(from other: [Element]) -> [Element] {
        let thisSet = Set(self)
        let otherSet = Set(other)
        return Array(thisSet.symmetricDifference(otherSet))
    }
}

// MARK: Sequence extensions

extension Sequence {

    /// Filter a sequence by a unique tag
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

public extension Sequence {

    /// Filter a Sequence by an unique keypath
    /// - Parameter keyPath: The keypath
    /// - Returns: The unique Sequence
    func uniqued<Type: Hashable>(by keyPath: KeyPath<Element, Type>) -> [Element] {
        var set = Set<Type>()
        return filter { set.insert($0[keyPath: keyPath]).inserted }
    }
}

// MARK: String extensions

extension String {

    /// Remove prefixes from a String
    /// - Parameter prefixes: An aray of prefixes
    /// - Returns: A String with al optonal prefixes removed
    func removePrefixes(_ prefixes: [String]) -> String {
        let pattern = "^(\(prefixes.map { "\\Q" + $0 + "\\E" }.joined(separator: "|")))\\s?"
        guard let range = self.range(of: pattern, options: [.regularExpression, .caseInsensitive]) else {
            return self
        }
        return String(self[range.upperBound...])
    }
}
