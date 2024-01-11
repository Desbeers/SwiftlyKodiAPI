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
    public func swapMoviesForSet() -> [any KodiItem] {
        let kodi = KodiConnector.shared
        if kodi.getKodiSetting(id: .videolibraryGroupMovieSets).bool {
            let movieSetIDs = Set(self.map(\.setID))
            let movieSets = kodi.library.movieSets
                .filter { movieSetIDs.contains($0.setID) }
            return (self.filter { $0.setID == 0 } + movieSets)
        }
        return self
    }
}
