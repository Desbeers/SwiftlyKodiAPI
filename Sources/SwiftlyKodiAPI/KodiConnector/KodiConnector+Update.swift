//
//  KodiConnector+Update.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {
    
    func getLibraryUpdate(itemID: Library.id, media: Library.Media) {
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
            case .tvshow:
                if let index = library.tvshows.firstIndex(where: {$0.tvshowID == itemID}) {
                    library.tvshows[index] = await VideoLibrary.getTVShowDetails(tvshowID: itemID)
                }
            case .episode:
                if let index = library.episodes.firstIndex(where: {$0.episodeID == itemID}) {
                    library.episodes[index] = await VideoLibrary.getEpisodeDetails(episodeID: itemID)
                    /// Always check the TV show when an episode is updated
                    getLibraryUpdate(itemID: library.episodes[index].tvshowID, media: .tvshow)
                }
            case .musicVideo:
                if let index = library.musicVideos.firstIndex(where: {$0.musicVideoID == itemID}) {
                    library.musicVideos[index] = await VideoLibrary.getMusicVideoDetails(musicVideoID: itemID)
                }
            default:
                logger("Library update for \(media) not implemented.")
            }
            /// Store the library in the cache
            await setLibraryCache()
        }
    }
    
    @MainActor public func updateLibrary() async {
        logger("Check for updates")
        
        let libraryUpdate = await getLibrary()
        library = libraryUpdate
        await setLibraryCache()
        
//        let updateSongs = await AudioLibrary.getSongs()
//
//        let update = updateSongs.difference(from: library.songs).unique(by: {$0.songID})
//
//        dump(update)

    }
}
