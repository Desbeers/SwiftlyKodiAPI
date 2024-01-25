//
//  Video+Details+Movie+Extensions.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

extension Array where Element == Video.Details.Movie {

    /// Search an array of ``Video/Details/Movie`` by the a query
    /// - Parameter query: The search query
    /// - Returns: An array of ``Video/Details/Movie``
    public func search(_ query: String) -> [Video.Details.Movie] {
        let searchMatcher = Search.Matcher(query: query)
        return self.filter { movies in
            return searchMatcher.matches(movies.search)
        }
    }
}

extension Array where Element == Video.Details.Movie {

    /// Swap movies for a set item
    /// 
    /// Movies that are part of a set will be removed and replaced with the set when enabled in the Kodi host
    /// - Returns: An array of ``KodiItem``
    /// - Parameter host: The ``HostItem`` that has the movie sets
    public func swapMoviesForSet(host: HostItem) async -> [any KodiItem] {
        /// Check if the setting to group movies into sets is enabled
        if await Settings.getSettingValue(
            host: host,
            setting: .videolibraryGroupMovieSets
        ).boolean {
            /// Get all movie sets
            var movieSets = await VideoLibrary.getMovieSets(host: host)
            /// Check if a set with just one movie should be grouped
            let singleItem = await Settings.getSettingValue(
                host: host,
                setting: .videolibraryGroupSingleItemSets
            ).boolean
            switch singleItem {
            case true:
                let movieSetIDs = Set(self.map(\.setID))
                movieSets = movieSets.filter { movieSetIDs.contains($0.setID) }
                return (self.filter { $0.setID == 0 } + movieSets)
            case false:
                var moviesBySet = Dictionary(grouping: self) { item in
                    item.setID
                }
                /// Remove setID 0, because it means 'not part of a set'
                moviesBySet.updateValue([], forKey: 0)
                let movieSetIDs = moviesBySet.filter { $0.value.count > 1 } .map {$0.key}
                movieSets = movieSets.filter { movieSetIDs.contains($0.setID) }
                return (self.filter { !movieSetIDs.contains($0.setID) } + movieSets)
            }
        } else {
            return self
        }
    }
}
