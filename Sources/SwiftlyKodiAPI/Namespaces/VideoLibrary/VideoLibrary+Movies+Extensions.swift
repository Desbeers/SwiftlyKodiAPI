//
//  VideoLibrary+Movies+Extensions.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
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
