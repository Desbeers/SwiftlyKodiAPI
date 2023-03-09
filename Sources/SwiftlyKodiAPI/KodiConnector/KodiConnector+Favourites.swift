//
//  KodiConnector+Favourites.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

// MARK: Favourites

extension KodiConnector {

    /// Get Favourites
    /// - Note: Only 'real' media' is supported
    /// - Returns: All 'media' favourites
    public func getFavourites() async -> [any KodiItem] {
        var items: [any KodiItem] = []
        let favs = await Favourites.getFavourites().filter({$0.type == "media"}).compactMap(\.path)
        for fav in favs {
            if let movie = library.movies.first(where: {$0.file == fav}) {
                items.append(movie)
            }
            if let episode = library.episodes.first(where: {$0.file == fav}) {
                items.append(episode)
            }
            if let musicVideo = library.musicVideos.first(where: {$0.file == fav}) {
                items.append(musicVideo)
            }
        }
        return items
    }
}
