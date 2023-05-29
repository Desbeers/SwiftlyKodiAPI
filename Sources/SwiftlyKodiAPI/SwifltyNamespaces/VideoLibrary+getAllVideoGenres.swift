//
//  VideoLibrary+getAllVideoGenres.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

extension VideoLibrary {

    // MARK: VideoLibrary.getAllVideoGenres

    /// Get all video genres from the Kodi host (SwiftlyKodi API)
    /// - Returns: All video genres from the Kodi host
    public static func getAllVideoGenres() async -> [Library.Details.Genre] {
        /// Get the genres for all media types
        let movieGenres = await VideoLibrary.getGenres(type: .movie)
        let tvGenres = await VideoLibrary.getGenres(type: .tvshow)
        let musicGenres = await VideoLibrary.getGenres(type: .musicVideo)
        /// Combine and return them
        return (movieGenres + tvGenres + musicGenres).unique { $0.id }
    }
}
