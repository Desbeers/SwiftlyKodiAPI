//
//  File.swift
//  
//
//  Created by Nick Berendsen on 09/03/2022.
//

import Foundation

extension KodiConnector {
    
    /// Connect to a Kodi host and load the library
    /// - Parameter kodiHost: The host configuration
    @MainActor public func connectToHost(kodiHost: HostItem) async {
        host = kodiHost
        loadingState = .cache
        if let libraryItems = Cache.get(key: "Media", as: [MediaItem].self) {
            logger("Loaded the library from the cache")
            media = libraryItems
        } else {
            let libraryItems = await getAllMedia()
            media = libraryItems
        }
        logger("Loaded the library")
        loadingState = .done
    }
    
    /// Reload the library from the Kodi host
    @MainActor public func reloadHost() async {
        loadingState = .reload
        let libraryItems = await getAllMedia()
        media = libraryItems
    }
    
    /// Get all media from the Kodi host library
    /// - Returns: All the media from the Kodi host library
    func getAllMedia() async -> [MediaItem] {
        logger("Load the library from the host")
        /// Start with a fresh list
        var items: [MediaItem] = []
        loadingState = .movies
        var movieSets = await getMovieSets()
        /// - Note: The ``getMovies`` function will add info to the movie sets
        await items += getMovies(movieSets: &movieSets)
        /// Now we can store the movie sets in the `items` array
        items += movieSets
        
        loadingState = .tvshows
        var tvshows = await getTVshows()
        /// - Note: The ``getAllEpisodes`` function will add info to the TV show items
        await items += getAllEpisodes(tvshows: &tvshows)
        /// Now we can store the TV shows in the `items` array
        items += tvshows
        
        loadingState = .musicVideos
        await items += getMusicVideos()
        
        loadingState = .artists
        await items += getArtists()
        
        loadingState = .artists
        var albums = await getAlbums()
        
        loadingState = .songs
        await items += getAllSongs(albums: &albums)
        items += albums
        
        loadingState = .genres
        await items += getAllGenres()
        
        /// Save it in the cache
        do {
            try Cache.set(key: "Media", object: items)
        } catch {
            /// There are no songs in the library
            print("Saving media failed with error: \(error)")
        }
        
        /// That's all!
        loadingState = .done
        return items
    }
    
    /// The loading status of the library
    public enum loadingStatus: String {
        case start = "Connecting to the host"
        case reload = "Loading you library from the host"
        case cache = "Loading library from the cache"
        case movies = "Loading movies"
        case tvshows = "Loading TV shows"
        case musicVideos = "Loading Music Videos"
        case artists = "Loading artists"
        case albums = "Loading albums"
        case songs = "Loading songs"
        case genres = "Loading genres"
        case done = "Library is loaded"
    }
}
