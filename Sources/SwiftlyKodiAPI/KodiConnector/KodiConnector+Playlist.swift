//
//  KodiConnector+Playlist.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

extension KodiConnector {

    @MainActor
    func getUserPlaylists() async {
        /// Audio is easy, it is just songs
        library.audioPlaylists = await Files.getDirectory(host: host, directory: "special://musicplaylists", media: .music)

        var moviePlaylists: [List.Item.File] = []

        let videoPlaylists = await Files.getDirectory(host: host, directory: "special://videoplaylists", media: .video)

        for videoPlaylist in videoPlaylists {
            let items = await Files.getDirectory(host: host, directory: videoPlaylist.file, media: .video)

            if let first = items.first {
                switch first.type {

                case .movie:
                    moviePlaylists.append(videoPlaylist)
                default:
                    break
                }
            }
        }
        library.moviePlaylists = moviePlaylists
    }

    @MainActor
    func getCurrentPlaylists() async {
        /// Get Player playlists
        await getCurrentPlaylist(host: host, media: .none)
    }
}
