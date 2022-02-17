//
//  File.swift
//  
//
//  Created by Nick Berendsen on 10/02/2022.
//

import Foundation

extension String {
    
    // MARK: kodiFileUrl (function)
    
    /// Convert internal Kodi path to a full URL
    /// - Returns: A string representing the full file URL
    func kodiFileUrl(media: KodiClient.KodiFile) -> String {
        let host = KodiClient.shared.host
        /// Encoding
        var allowed = CharacterSet.alphanumerics
        allowed.insert(charactersIn: ":-._~") /// as per RFC 3986
        /// Image URL
        let kodiImageAddress = "http://\(host.username):\(host.password)@\(host.ip):\(host.port)/\(media.rawValue)/"
        return kodiImageAddress + self.addingPercentEncoding(withAllowedCharacters: allowed)!
    }
}

extension Array where Element == GenericItem {
    func uniqueSet() -> [GenericItem] {
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

extension Array where Element == GenericItem {
    
    /// Standard sorting for movies; sets will be included in alphabetic orther
    func sortBySetAndTitle() -> [GenericItem] {
        return self.sorted {
            $0.sortBySetAndTitle < $1.sortBySetAndTitle
        }
    }
    
    /// First sort by year, than by title. Used insde moviesets en music videos from a specific artist
    func sortByYearAndTitle() -> [GenericItem] {
        return self.sorted {
            $0.releaseDate == $1.releaseDate ?
            $0.sortByTitle.localizedStandardCompare($1.sortByTitle) == .orderedAscending :
            $0.releaseDate < $1.releaseDate
        }
    }
}

extension Sequence {
    func unique<T: Hashable>(by taggingHandler: (_ element: Self.Iterator.Element) -> T) -> [Self.Iterator.Element] {
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
