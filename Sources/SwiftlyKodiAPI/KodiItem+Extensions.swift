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
    /// - Returns: A updated Kodi item
    @MainActor public func toggleWatchedState() -> KodiItem {
        return KodiConnector.shared.toggleWatchedState(self)
    }
}

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

    
    
    /// Filter the Kodi library
    public func filter(_ filter: KodiFilter) -> [KodiItem] {
        
        return KodiConnector.shared.filter(filter)
//
//        /// Start with an empty array
//        var items: [KodiItem] = []
//
//        switch filter.media {
//        case .movie:
//            /// If `setID` is set it means we want movies from a specific set
//            if let setID = filter.setID {
//                items = self.filter { $0.media == .movie && $0.setID == setID }
//                .sortByYearAndTitle()
//            } else {
//                items = self.filter { $0.media == .movie }
//                .uniqueSet()
//                .sortBySetAndTitle()
//            }
//        case .tvshow:
//            items = self.filter { $0.media == .tvshow}
//        case .episode:
//            items = self.filter { $0.media == .episode && $0.tvshowID == filter.tvshowID }
//        case .musicvideo:
//            /// If `artist` is set we filter music videos for this specific artist
//            if let artist = filter.artist {
//                items = self
//                    .filter { $0.media == .musicvideo }
//                    .filter { $0.artist.contains(artist.first ?? "") }
//                    .sorted { $0.releaseDate < $1.releaseDate }
//            } else {
//                /// Filter for one music video for earch artist to build an Artist View
//                items = self.filter { $0.media == .musicvideo } .unique { $0.artist }
//            }
//        case .all:
//            items = self
//        default:
//            items = [KodiItem]()
//        }
//        /// Now that filtering on media type is done, check if some additional fitereing is needed
//        if let genre = filter.genre {
//            items = items
//                .filter { $0.genre.contains(genre) }
//                .sortBySetAndTitle()
//            if filter.setID == nil {
//                items = items.uniqueSet()
//            }
//        }
//        /// That should be it!
//        return items
//
////        return self.sorted {
////            $0.releaseDate == $1.releaseDate ?
////            $0.sortByTitle.localizedStandardCompare($1.sortByTitle) == .orderedAscending :
////            $0.releaseDate < $1.releaseDate
////        }
    }
    
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
