//
//  Application+getItem.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

// MARK: getItem

extension Application {

    /// Get an item from the application (SwiftlyKodi API)
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - type: The ``Library/Media`` type
    ///   - id: Ithe ID of the library item
    /// - Returns: A ``KodiItem``, if found, else `nil`
    public static func getItem(host: HostItem, type: Library.Media, id: Library.ID) async -> (any KodiItem)? {
        switch type {
        case .song:
            await AudioLibrary.getSongDetails(host: host, songID: id)
        case .musicVideo:
            await VideoLibrary.getMusicVideoDetails(host: host, musicVideoID: id)
        case .movie:
            await VideoLibrary.getMovieDetails(host: host, movieID: id)
        case .episode:
            await VideoLibrary.getEpisodeDetails(host: host, episodeID: id)
        default:
            nil
        }
    }
}
