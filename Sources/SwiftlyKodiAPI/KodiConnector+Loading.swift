//
//  KodiConnector+Loading.swift
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
        
        if let libraryItems = Cache.get(key: "MyLibrary", as: MyLibrary.self) {
            library = libraryItems
        } else {
            await getMedia()
        }
        
//        if let libraryItems = Cache.get(key: "Media", as: [MediaItem].self) {
//            media = libraryItems
//        } else {
//            let libraryItems = await getAllMedia()
//            media = libraryItems
//        }
        
        /// Get the state of the player
        await getPlayerState()
        logger("Loaded the library")
        loadingState = .done
    }
    
    /// Reload the library from the Kodi host
    @MainActor public func reloadHost() async {
        loadingState = .load
        await getMedia()
        //media = libraryItems
    }
    
    
    @MainActor func getMedia() async {
        logger("Getting your media")
        switch host.media {
            
        case .music:
            
            async let artist = AudioLibrary.getArtists()
            async let albums = AudioLibrary.getAlbums()
            /// Limit the loading for debugging
            /// let songs = await AudioLibrary.getSongs(limits: List.Limits(end: 400, start: 100))
            async let songs = AudioLibrary.getSongs()
            async let audioGenres = AudioLibrary.getGenres()
            
            library = await MyLibrary(artists: artist,
                                      albums: albums,
                                      songs: songs,
                                      audioGenres: audioGenres
            )
        case .video:
            
            async let movies = VideoLibrary.getMovies()
            async let movieSets = VideoLibrary.getMovieSets()
            async let tvshows = VideoLibrary.getTVShows()
            async let episodes = VideoLibrary.getEpisodes()
            async let musicVideos = VideoLibrary.getMusicVideos()
            async let videoGenres = getAllVideoGenres()
            
            library = await MyLibrary(movies: movies,
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
            
            library = await MyLibrary(artists: artist,
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
            return
        }
        setLibraryCache()
    }
    
    /// Get all media from the Kodi host library
    /// - Returns: All the media from the Kodi host library
    @MainActor func getAllMedia() async -> [MediaItem] {
        logger("Load the library from the host")
        
        /// Start with a fresh list
        var items: [MediaItem] = []
        
//        /// Always load Artist
//        loadingState = .artists
//        await items += AudioLibrary.getArtists()
        
        
//        /// Load videos
//        if host.media == .video || host.media == .all {
//
//            loadingState = .movies
//            /// - Note: Always load Movies before Movie Sets, the latter is using Movie info
//            //await items += VideoLibrary.getMovies()
//            await items += VideoLibrary.getMovieSets()
//
//            loadingState = .tvshows
//            let tvshows = await VideoLibrary.getTVShows()
//            /// - Note: The ``getAllEpisodes`` needs the list of TV shows
//            //await items += getAllEpisodes(tvshows: tvshows)
//            await items += VideoLibrary.getEpisodes()
//            /// Now we can store the TV shows in the `items` array
//            items += tvshows
//
//            loadingState = .musicVideos
//            await items += VideoLibrary.getMusicVideos()
//        }
        
//        /// Load audio
//        if host.media == .music || host.media == .all {
//            loadingState = .albums
//            let albums = await AudioLibrary.getAlbums()
//            items += albums
//
//            loadingState = .songs
//            await items += getAllSongs(albums: albums)
//        }
        
        loadingState = .genres
        //await items += getAllGenres()
        
        /// Store the media in the cache
        storeMediaInCache(media: items)
        
        /// That's all!
        loadingState = .done
        return items
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
    
    /// Store the media library in the cache
    
    /// Store the media library in the cache
    /// - Parameter media: The whole media libray
    /// - Note: This function will debounce for 2 seconds to avoid
    ///         overload when we have a large library update
    func storeMediaInCache(media: [MediaItem]) {
        cacheTimer?.invalidate()
        cacheTimer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: false) { _ in
            Task.detached {
                do {
                    try Cache.set(key: "Media", object: media)
                } catch {
                    print("Saving media failed with error: \(error)")
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
