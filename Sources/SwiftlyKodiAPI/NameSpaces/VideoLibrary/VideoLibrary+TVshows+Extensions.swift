//
//  VideoLibrary+TVshows+Extensions.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Array where Element == Video.Details.TVShow {

    /// Search an array of ``Video/Details/TVShow`` by the a query
    /// - Parameter query: The search query
    /// - Returns: An array of ``Video/Details/TVShow``
    public func search(_ query: String) -> [Video.Details.TVShow] {
        let searchMatcher = Search.Matcher(query: query)
        return self.filter { tvshows in
            return searchMatcher.matches(tvshows.search)
        }
    }
}
