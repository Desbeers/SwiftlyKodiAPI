//
//  KodiConnector+Load.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {
    
    /// Connect to a Kodi host and load the library
    /// - Parameter kodiHost: The host configuration
    @MainActor public func connectToHost(kodiHost: HostItem) async {
        host = kodiHost
        connectWebSocket()
        loadingState = .load
        
        /// Get the properties of the host
        
        properties = await Application.getProperties()
        
        if let libraryItems = Cache.get(key: "MyLibrary", as: MyLibrary.self) {
            library = libraryItems
        } else {
            library = await getLibrary()
            setLibraryCache()
        }
        
        /// Get Playlists
        
        audioPlaylists = await Files.getDirectory(directory: "special://musicplaylists", media: .music)
        
        /// Get the state of the player
        await getPlayerState()
        /// Get all items in the playlist
        await getCurrentPlaylist()
        logger("Loaded the library")
        loadingState = .done
    }
    
    /// Reload the library from the Kodi host
    @MainActor public func reloadHost() async {
        loadingState = .load
        library = await getLibrary()
        setLibraryCache()
        loadingState = .done
    }
    
    
    @MainActor func getLibrary() async -> MyLibrary {
        logger("Getting your library")
        switch host.media {
            
        case .audio:
            
            async let artist = AudioLibrary.getArtists()
            async let albums = AudioLibrary.getAlbums()
            /// Limit the loading for debugging
            /// let songs = await AudioLibrary.getSongs(limits: List.Limits(end: 400, start: 100))
            async let songs = AudioLibrary.getSongs()
            async let musicVideos = VideoLibrary.getMusicVideos()
            async let audioGenres = AudioLibrary.getGenres()
            
            return await MyLibrary(artists: artist,
                                   albums: albums,
                                   songs: songs,
                                   audioGenres: audioGenres,
                                   musicVideos: musicVideos
            )
            
        case .video:
            
            async let artist = AudioLibrary.getArtists()
            async let movies = VideoLibrary.getMovies()
            async let movieSets = VideoLibrary.getMovieSets()
            async let tvshows = VideoLibrary.getTVShows()
            async let episodes = VideoLibrary.getEpisodes()
            async let musicVideos = VideoLibrary.getMusicVideos()
            async let videoGenres = getAllVideoGenres()
            
            return await MyLibrary(artists: artist,
                                      movies: movies,
                                      movieSets: movieSets,
                                      tvshows: tvshows,
                                      episodes: episodes,
                                      musicVideos: musicVideos,
                                      videoGenres: videoGenres
            )
        case .all:
            
            async let artist = AudioLibrary.getArtists()
            async let albums = AudioLibrary.getAlbums()
            /// Limit the loading for debugging
            /// let songs = await AudioLibrary.getSongs(limits: List.Limits(end: 400, start: 100))
            async let songs = AudioLibrary.getSongs()
            async let audioGenres = AudioLibrary.getGenres()
            
            /// # Video
            
            async let movies = VideoLibrary.getMovies()
            async let movieSets = VideoLibrary.getMovieSets()
            async let tvshows = VideoLibrary.getTVShows()
            async let episodes = VideoLibrary.getEpisodes()
            async let musicVideos = VideoLibrary.getMusicVideos()
            async let videoGenres = getAllVideoGenres()
            
            return await MyLibrary(artists: artist,
                                      albums: albums,
                                      songs: songs,
                                      audioGenres: audioGenres,
                                      movies: movies,
                                      movieSets: movieSets,
                                      tvshows: tvshows,
                                      episodes: episodes,
                                      musicVideos: musicVideos,
                                      videoGenres: videoGenres
            )
        default:
            return MyLibrary()
        }
        //setLibraryCache()
    }
    
    /// Store the library in the cache
    /// - Parameter media: The whole media libray
    /// - Note: This function will debounce for 2 seconds to avoid
    ///         overload when we have a large library update
    func setLibraryCache() {
        cacheTimer?.invalidate()
        cacheTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
            Task.detached {
                do {
                    try Cache.set(key: "MyLibrary", object: self.library)
                } catch {
                    print("Saving library failed with error: \(error)")
                }
            }
        }
    }
    
    /// The loading status of the library
    public enum loadingStatus: String {
        case start = "Connecting..."
        case load = "Loading library..."
        case movies = "Loading movies..."
        case tvshows = "Loading TV shows..."
        case musicVideos = "Loading Music Videos..."
        case artists = "Loading artists..."
        case albums = "Loading albums..."
        case songs = "Loading songs..."
        case genres = "Loading genres..."
        case done = "Library is loaded..."
    }
}

extension KodiConnector {
    
    /// Get all video genres from the Kodi host
    /// - Returns: All video genres from the Kodi host
    func getAllVideoGenres() async -> [Library.Details.Genre] {
        /// Get the genres for all media types
        let movieGenres = await VideoLibrary.getGenres(type: .movie)
        let tvGenres = await VideoLibrary.getGenres(type: .tvshow)
        let musicGenres = await VideoLibrary.getGenres(type: .musicVideo)
        /// Combine and return them
        return (movieGenres + tvGenres + musicGenres).unique { $0.id}
    }
}
