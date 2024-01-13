//
//  VideoLibrary+getAllVideoGenres.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

// MARK: getAllVideoGenres

extension VideoLibrary {

    /// Get all video genres from the Kodi host (SwiftlyKodi API)
    /// - Parameter host: The ``HostItem`` for the request
    /// - Returns: All video genres from the Kodi host
    public static func getAllVideoGenres(host: HostItem) async -> [Library.Details.Genre] {
        /// Get the genres for all media types
        let movieGenres = await VideoLibrary.getGenres(host: host, type: .movie)
        let tvGenres = await VideoLibrary.getGenres(host: host, type: .tvshow)
        let musicGenres = await VideoLibrary.getGenres(host: host, type: .musicVideo)
        /// Combine and return them
        return (movieGenres + tvGenres + musicGenres).unique { $0.id }
    }
}
