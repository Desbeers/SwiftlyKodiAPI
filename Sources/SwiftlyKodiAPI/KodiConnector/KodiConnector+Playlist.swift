//
//  KodiConnector+Playlist.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

extension KodiConnector {

    struct Playlist {
        var media: Library.Media
        var title: String
        var movies: [Video.Details.Movie]
    }

    @MainActor func getUserPlaylists() async {
        /// Audio is easy, it is just songs
        library.audioPlaylists = await Files.getDirectory(directory: "special://musicplaylists", media: .music)
        //library.videoPlaylists = await Files.getDirectory(directory: "special://videoplaylists", media: .video)

        var moviePlaylists: [List.Item.File] = []

        let videoPlaylists = await Files.getDirectory(directory: "special://videoplaylists", media: .video)

        for videoPlaylist in videoPlaylists {
            let items = await Files.getDirectory(directory: videoPlaylist.file, media: .video)

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

    @MainActor func getCurrentPlaylists() async {
        /// Get Player playlists
        await KodiPlayer.shared.getCurrentPlaylist(media: .none)
    }
}
