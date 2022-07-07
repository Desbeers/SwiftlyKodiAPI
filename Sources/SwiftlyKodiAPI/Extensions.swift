//
//  Extensions.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
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
