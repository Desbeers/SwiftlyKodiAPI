//
//  Search.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

/// Search related functions
enum Search {
    /// Just a placeholder
}

extension Search {
    /// A struct for searching the library a bit smart
    /// - Note: Based on code from https://github.com/hacknicity/SmartSearchExample
    struct Matcher {
        /// Creates a new instance for testing matches against `query`.
        public init(query: String) {
            /// Split `query` into tokens by whitespace and sort them by decreasing length
            searchTokens = query.split(whereSeparator: { $0.isWhitespace }).sorted { $0.count > $1.count }
        }
        /// Check if `candidateString` matches `searchString`.
        func matches(_ candidateString: String) -> Bool {
            /// If there are no search tokens, everything matches
            guard !searchTokens.isEmpty else {
                return true
            }
            /// Split `candidateString` into tokens by whitespace
            var candidateStringTokens = candidateString.split(whereSeparator: { $0.isWhitespace })
            /// Iterate over each search token
            for searchToken in searchTokens {
                /// We haven't matched this search token yet
                var matchedSearchToken = false
                /// Iterate over each candidate string token
                for (candidateStringTokenIndex, candidateStringToken) in candidateStringTokens.enumerated() {
                    /// Does `candidateStringToken` start with `searchToken`?
                    if let range = candidateStringToken.range(of: searchToken, options: [.caseInsensitive, .diacriticInsensitive]),
                       range.lowerBound == candidateStringToken.startIndex {
                        matchedSearchToken = true
                        /// Remove the candidateStringToken so we don't match it again against a different searchToken.
                        candidateStringTokens.remove(at: candidateStringTokenIndex)
                        /// Check the next search string token
                        break
                    }
                }
                // If we failed to match `searchToken` against the candidate string tokens, there is no match
                guard matchedSearchToken else {
                    return false
                }
            }
            // If we match every `searchToken` against the candidate string tokens, `candidateString` is a match
            return true
        }
        /// The tokens to search for
        private(set) var searchTokens: [String.SubSequence]
    }
}

extension Array where Element == Audio.Details.Song {

    /// Filter a list of songs matching the search query
    /// - Parameter query: The search query
    /// - Returns: An array of ``Audio/Details/Song``
    public func search(_ query: String) -> [Audio.Details.Song] {
        let searchMatcher = Search.Matcher(query: query)
        return self.filter { songs in
            return searchMatcher.matches(songs.search)
        }
    }
}

extension Array where Element == Video.Details.Movie {
    
    /// Filter a list of movies matching the search query
    /// - Parameter query: The search query
    /// - Returns: An array of ``Video/Details/Movie``
    public func search(_ query: String) -> [Video.Details.Movie] {
        let searchMatcher = Search.Matcher(query: query)
        return self.filter { movies in
            return searchMatcher.matches(movies.search)
        }
    }
}

extension Array where Element == Video.Details.TVShow {
    
    /// Filter a list of tv shows matching the search query
    /// - Parameter query: The search query
    /// - Returns: An array of ``Video/Details/TVShow``
    public func search(_ query: String) -> [Video.Details.TVShow] {
        let searchMatcher = Search.Matcher(query: query)
        return self.filter { tvshows in
            return searchMatcher.matches(tvshows.search)
        }
    }
}
