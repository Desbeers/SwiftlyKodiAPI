//
//  KodiConnector+Update.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {
    
    func getLibraryUpdate(itemID: Int, media: Library.Media) {
        Task { @MainActor in
            switch media {
            case .song:
                if let index = library.songs.firstIndex(where: {$0.songID == itemID}) {
                    library.songs[index] = await AudioLibrary.getSongDetails(songID: itemID)
                }
            case .movie:
                if let index = library.movies.firstIndex(where: {$0.movieID == itemID}) {
                    library.movies[index] = await VideoLibrary.getMovieDetails(movieID: itemID)
                }
            default:
                logger("Library update for \(media) not implemented.")
            }
            /// Store the library in the cache
            setLibraryCache()
        }
    }
}
