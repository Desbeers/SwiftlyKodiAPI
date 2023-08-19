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
    public func getFavourites() async -> [AnyKodiItem] {
        var items: [any KodiItem] = []
        let favs = await Favourites
            .getFavourites()

        for fav in favs {

            switch fav.type {
            case "media":
                if let movie = library.movies.first(where: { $0.file == fav.path }) {
                    items.append(movie)
                }
                if let episode = library.episodes.first(where: { $0.file == fav.path }) {
                    items.append(episode)
                }
                if let musicVideo = library.musicVideos.first(where: { $0.file == fav.path }) {
                    items.append(musicVideo)
                }
            default:
                if let tvshow = library.tvshows.first(where: { $0.title == fav.title }) {
                    items.append(tvshow)
                }
                if let episode = library.episodes.first(where: { $0.thumbnail == fav.thumbnail }) {
                    items.append(episode)
                }
            }

//            if let movie = library.movies.first(where: { $0.file == fav }) {
//                items.append(movie)
//            }
//            if let tvshow = library.tvshows.first(where: { $0.file == fav }) {
//                items.append(tvshow)
//            }
//            if let episode = library.episodes.first(where: { $0.file == fav }) {
//                items.append(episode)
//            }
//            if let musicVideo = library.musicVideos.first(where: { $0.file == fav }) {
//                items.append(musicVideo)
//            }
        }
        return items.anykodiItem()
    }
}
