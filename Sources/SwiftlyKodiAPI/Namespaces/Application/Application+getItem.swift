//
//  Application+getItem.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

// MARK: getItem

extension Application {

    /// Get an item from the application (SwiftlyKodi API)
    public static func getItem(type: Library.Media, id: Library.ID) async -> (any KodiItem)? {

        let kodi: KodiConnector = .shared

        switch type {
        case .song:
            if kodi.library.songs.isEmpty {
                return await AudioLibrary.getSongDetails(songID: id)
            } else {
                return kodi.library.songs.first(where: { $0.songID == id })
            }
        case .musicVideo:
            if kodi.library.musicVideos.isEmpty {
                return await VideoLibrary.getMusicVideoDetails(musicVideoID: id)
            } else {
                return kodi.library.musicVideos.first(where: { $0.musicVideoID == id })
            }
        case .movie:
            if kodi.library.movies.isEmpty {
                return await VideoLibrary.getMovieDetails(movieID: id)
            } else {
                return kodi.library.movies.first(where: { $0.movieID == id })
            }
        case .episode:
            if kodi.library.episodes.isEmpty {
                return await VideoLibrary.getEpisodeDetails(episodeID: id)
            } else {
                return kodi.library.episodes.first(where: { $0.episode == id })
            }
        default:
            return nil
        }
    }
}
