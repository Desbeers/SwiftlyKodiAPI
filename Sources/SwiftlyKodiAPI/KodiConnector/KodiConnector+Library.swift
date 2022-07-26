//
//  KodiConnector+Library.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {
    
    func getLibrary() async -> Library.Items {
        logger("Getting your library")
        
        /// Helpers
        
        @Sendable func getAudio() async -> Library.Items {
            async let albums = AudioLibrary.getAlbums()
            /// Limit the loading for debugging
            //let songs = await AudioLibrary.getSongs(filter: List.Filter(artistID: 43), limits: List.Limits(end: 400, start: 100))
            async let songs = AudioLibrary.getSongs()
            async let audioGenres = AudioLibrary.getGenres()
            async let audioLibraryProperties = AudioLibrary.getProperties()
            
            return await Library.Items(albums: albums,
                                       songs: songs,
                                       audioGenres: audioGenres,
                                       audioLibraryProperties: audioLibraryProperties
            )
        }
        
        @Sendable func getVideo() async -> Library.Items {
            async let movies = VideoLibrary.getMovies()
            async let movieSets = VideoLibrary.getMovieSets()
            async let tvshows = VideoLibrary.getTVShows()
            async let episodes = VideoLibrary.getEpisodes()
            async let videoGenres = getAllVideoGenres()
            
            return await Library.Items(movies: movies,
                                      movieSets: movieSets,
                                      tvshows: tvshows,
                                      episodes: episodes,
                                      videoGenres: videoGenres
            )
        }
        
        
        
        async let artist = AudioLibrary.getArtists()
        async let musicVideos = VideoLibrary.getMusicVideos()
        
        switch host.media {
            
        case .audio:
            async let audio = getAudio()
            return await Library.Items(artists: artist,
                                       albums: audio.albums,
                                       songs: audio.songs,
                                       audioGenres: audio.audioGenres,
                                       musicVideos: musicVideos,
                                       audioLibraryProperties: audio.audioLibraryProperties
            )
            
        case .video:
            async let video = getVideo()
            return await Library.Items(artists: artist,
                                       movies: video.movies,
                                       movieSets: video.movieSets,
                                       tvshows: video.tvshows,
                                       episodes: video.episodes,
                                       musicVideos: musicVideos,
                                       videoGenres: video.videoGenres
            )
        case .all:
            async let audio = getAudio()
            async let video = getVideo()
            return await Library.Items(artists: artist,
                                       albums: audio.albums,
                                       songs: audio.songs,
                                       audioGenres: audio.audioGenres,
                                       movies: video.movies,
                                       movieSets: video.movieSets,
                                       tvshows: video.tvshows,
                                       episodes: video.episodes,
                                       musicVideos: musicVideos,
                                       videoGenres: video.videoGenres
            )
        default:
            return Library.Items()
        }
    }
    
    /// Store the library in the cache
    /// - Parameter media: The whole media libray
    /// - Note: This function will debounce for 2 seconds to avoid
    ///         overload when we have a large library update
    func setLibraryCache() async {
        //cacheTimer?.invalidate()
        //        cacheTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
        await task.setLibraryCache.submit {
            do {
                try Cache.set(key: "MyLibrary", object: self.library)
            } catch {
                print("Saving library failed with error: \(error)")
            }
        }
    }
}
