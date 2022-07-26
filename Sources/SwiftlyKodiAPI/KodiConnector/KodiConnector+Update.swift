//
//  KodiConnector+Update.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {
    
    
    func getUpdatedSongs() async {
        let audioLibrary = await AudioLibrary.getProperties()
        
        if library.audioLibraryProperties.songsModified != audioLibrary.songsModified {
            logger("Songs are modified")
            
            let songs = await AudioLibrary.getSongs(modificationDate: library.audioLibraryProperties.songsModified)
            for song in songs {
                if let index = library.songs.firstIndex(where: {$0.songID == song.songID}) {
                    library.songs[index] = song
                    logger("Updated \(song.title)")
                }
            }
            await setLibraryCache()
        }
    }
    
    func getLibraryUpdate(itemID: Library.id, media: Library.Media) {
        Task { @MainActor in
            switch media {
            case .song:
                //logger("GET TIME")
                library.audioLibraryProperties = await AudioLibrary.getProperties()
                //logger("GET SONG")
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
}
