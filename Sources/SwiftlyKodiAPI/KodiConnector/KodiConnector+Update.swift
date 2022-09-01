//
//  KodiConnector+Update.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {
    
    
    @MainActor func getAudioLibraryUpdates() async {
        let dates = await AudioLibrary.getProperties()
        
        if dates != library.audioLibraryProperties {
            setState(.updatingLibrary)
            if library.audioLibraryProperties.songsModified != dates.songsModified {
                logger("Songs are modified")
                /// Update the songs
                let songs = await AudioLibrary.getSongs(modificationDate: library.audioLibraryProperties.songsModified)
                /// Don't bother if there are too many songs to update; just mark the library as 'outdated'
                if songs.count < 100 {
                    for song in songs {
                        if let index = library.songs.firstIndex(where: {$0.songID == song.songID}) {
                            library.songs[index] = song
                            logger("Updated \(song.title)")
                        }
                    }
                    /// Store the date
                    library.audioLibraryProperties.songsModified = dates.songsModified
                } else {
                    logger("Too many songs are modified")
                }
            }
            if library.audioLibraryProperties.artistsModified != dates.artistsModified {
                logger("Artists are modified")
            }
            
            /// Store the library in the cache
            await setLibraryCache()
        }
        /// Set the state
        setState(dates == library.audioLibraryProperties ? State.loadedLibrary : State.outdatedLibrary)
    }
    
    
    
    func getLibraryUpdate(itemID: Library.id, media: Library.Media) {
        Task { @MainActor in
            switch media {
            case .artist:
                let dates = await AudioLibrary.getProperties()
                library.audioLibraryProperties.artistsModified = dates.artistsModified
                if let index = library.artists.firstIndex(where: {$0.artistID == itemID}) {
                    library.artists[index] = await AudioLibrary.getArtistDetails(artistID: itemID)
                }
            case .song:
                let dates = await AudioLibrary.getProperties()
                library.audioLibraryProperties.songsModified = dates.songsModified
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
                
                let update = await VideoLibrary.getMusicVideoDetails(musicVideoID: itemID)
                
                if let index = library.musicVideos.firstIndex(where: {$0.musicVideoID == itemID}) {
                    library.musicVideos[index] = update
                } else {
                    library.musicVideos.append(update)
                }
            default:
                logger("Library update for \(media) not implemented.")
            }
            /// Store the library in the cache
            await setLibraryCache()
        }
    }
    
    func deleteLibraryItem(itemID: Library.id, media: Library.Media) {
        Task { @MainActor in
            switch media {
            case .artist:
                if let index = library.artists.firstIndex(where: {$0.artistID == itemID}) {
                    library.artists.remove(at: index)
                }
            case .song:
                if let index = library.songs.firstIndex(where: {$0.songID == itemID}) {
                    library.songs.remove(at: index)
                }
            case .movie:
                if let index = library.movies.firstIndex(where: {$0.movieID == itemID}) {
                    library.movies.remove(at: index)
                }
            case .tvshow:
                if let index = library.tvshows.firstIndex(where: {$0.tvshowID == itemID}) {
                    library.tvshows.remove(at: index)
                }
            case .episode:
                if let index = library.episodes.firstIndex(where: {$0.episodeID == itemID}) {
                    library.episodes.remove(at: index)
                }
            case .musicVideo:
                if let index = library.musicVideos.firstIndex(where: {$0.musicVideoID == itemID}) {
                    library.musicVideos.remove(at: index)
                }
            default:
                logger("Library delete for \(media) not implemented.")
            }
            logger("Removed \(media) \(itemID) from the library")
            /// Store the library in the cache
            await setLibraryCache()
        }
    }
}
