//
//  SwiftUIView.swift
//  
//
//  Created by Nick Berendsen on 23/02/2022.
//

import SwiftUI

extension KodiItem {

    /// Get the binding from a Kodi item to the Kodi library
    /// - Returns: A Binding to the library
    public func binding() -> Binding<KodiItem> {
        return KodiConnector.shared.getLibraryBinding(item: self)
    }
    
    /// Toggle the watched status of a Kodi item
    mutating public func toggleWatchedState() {
        self.playcount = self.playcount == 0 ? 1 : 0
        KodiConnector.shared.setPlaycount(self)
    }
    
    /// Mark an Kodi item as watched
    mutating public func markAsWatched() {
        self.playcount += 1
        KodiConnector.shared.setPlaycount(self)
    }
}

extension Array where Element == KodiItem {
    
    /// Filter the movies to have only one movie representing a set
    /// - Returns: A list with movies without duplicated sets
    mutating func uniqueSet() {
        var knownSets = Set<Int>()
        self = self.filter { element -> Bool in
            let set = element.setID
            if set == 0 || !knownSets.contains(set) {
                knownSets.insert(set)
                return true
            }
            /// This set is already in the list
            return false
        }
    }

    /// Filter the Kodi library
    public func filter(_ filter: KodiFilter) -> [KodiItem] {
        return KodiConnector.shared.filter(filter)
    }
    
    /// Standard sorting for movies; sets will be included in alphabetic order
    mutating func sortBySetAndTitle() {
        self = self.sorted {
            $0.sortBySetAndTitle < $1.sortBySetAndTitle
        }
    }
    
    /// Sort first by year, than by title. Used insde moviesets and music videos from a specific artist
    mutating func sortByYearAndTitle() {
        self = self.sorted {
            $0.releaseDate == $1.releaseDate ?
            $0.sortByTitle.localizedStandardCompare($1.sortByTitle) == .orderedAscending :
            $0.releaseDate < $1.releaseDate
        }
    }
}
