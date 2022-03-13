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
        connectWebSocket()
        loadingState = .load
        if let libraryItems = Cache.get(key: "Media", as: [MediaItem].self) {
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
        loadingState = .load
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
        
        /// Store the media in the cache
        storeMediaInCache(media: items)
        
        /// That's all!
        loadingState = .done
        return items
    }
    
    /// Store the modia library in the cache
    
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
    
    /// Set the state of Kodio and act on it
    @MainActor func setState(current: State) {
        logger("Kodio status: \(current.rawValue)")
        state = current
        DispatchQueue.global(qos: .background).async {
            //self.action(state: current)
        }
    }
    
    /// The general status of the KodiConnector bridge
    enum State: String {
        /// Not connected and no host
        case none
        /// Connected to the Kodi host
        case connectedToHost
        /// Loading the library
        case loadingLibrary
        /// The library is  loaded
        case loadedLibrary
        /// Kodio is sleeping
        case sleeping
        /// Kodio is waking up
        case wakeup
        /// An error when loading the library or a lost of connection
        case failure
        /// Kodio has no host configuration
        case noHostConfig
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
