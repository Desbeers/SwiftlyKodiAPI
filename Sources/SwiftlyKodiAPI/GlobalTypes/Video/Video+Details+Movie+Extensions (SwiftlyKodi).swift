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
        if await Settings.getSettingValue(
            host: host,
            setting: .videolibraryGroupMovieSets
        ).boolean {
            let moviesBySet = Dictionary(grouping: self) { item in
                item.setID
            }
            var movieSets = await VideoLibrary.getMovieSets(host: host)
            let movieSetIDs = moviesBySet.filter { $0.value.count > 1 } .map {$0.key}
            movieSets = movieSets.filter { movieSetIDs.contains($0.setID) }
            return ((moviesBySet[0] ?? []) + movieSets)
        } else {
            return self
        }
    }
}
