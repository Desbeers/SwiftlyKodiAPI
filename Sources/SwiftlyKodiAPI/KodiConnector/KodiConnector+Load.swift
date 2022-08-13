//
//  KodiConnector+Load.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {
    
    public func connect(host: HostItem) {
        /// Start with a blank sheet
        Task {
            await setState(.offline)
        }
        self.host = host
        if host.isOnline {
            makeConnection()
        }
    }
    
    func makeConnection() {
        connectWebSocket()
    }
    
    func getKodiState() async {
        //Task {
            //await KodiPlayer.shared.getCurrentPlaylist()
            await KodiPlayer.shared.getPlayerProperties()
            await KodiPlayer.shared.getPlayerItem()
            /// Get the properties of the host
            properties = await Application.getProperties()
            /// Send the properties to the KodiPlayer Class
            await KodiPlayer.shared.setApplicationProperties(properties: properties)
        //}
    }
    
    func getCurrentPlaylists() async {
        await KodiPlayer.shared.getCurrentPlaylist()
    }
    
    @MainActor func loadLibrary() async {
        setState(.loadingLibrary)
        if let libraryItems = Cache.get(key: "MyLibrary", as: Library.Items.self) {
            library = libraryItems
            if host.media == .audio {
                await getAudioLibraryUpdates()
            } else {
                setState(.loadedLibrary)
            }
        } else {
            library = await getLibrary()
            await setLibraryCache()
            setState(.loadedLibrary)
        }
        
    }
    
    /// Connect to a Kodi host and load the library
    /// - Parameter kodiHost: The host configuration
    @MainActor public func connectToHost(kodiHost: HostItem) async {
        host = kodiHost
        /// Get the state of the player
        await KodiPlayer.shared.getPlayerProperties()
        await KodiPlayer.shared.getPlayerItem()
        connectWebSocket()
        setState(.loadingLibrary)
        /// Get the properties of the host
        properties = await Application.getProperties()
        /// Send the properties to the KodiPlayer Class
        KodiPlayer.shared.setApplicationProperties(properties: properties)
        
        if let libraryItems = Cache.get(key: "MyLibrary", as: Library.Items.self) {
            library = libraryItems
            if host.media == .audio {
                await getAudioLibraryUpdates()
            } else {
                setState(.loadedLibrary)
            }
        } else {
            library = await getLibrary()
            await setLibraryCache()
            setState(.loadedLibrary)
        }
        
        /// Get Playlists
        library.audioPlaylists = await Files.getDirectory(directory: "special://musicplaylists", media: .music)
        
//        /// Get the state of the player
//        await KodiPlayer.shared.getPlayerProperties()
//        await KodiPlayer.shared.getPlayerItem()
        /// Get all items in the playlist
        await KodiPlayer.shared.getCurrentPlaylist()
    }
    
    /// Reload the library from the Kodi host
    @MainActor public func reloadHost() async {
        setState(.loadingLibrary)
        library = await getLibrary()
        library.audioLibraryProperties = await AudioLibrary.getProperties()
        /// Get Playlists
        library.audioPlaylists = await Files.getDirectory(directory: "special://musicplaylists", media: .music)
        
        if host.media == .audio {
            await getAudioLibraryUpdates()
        } else {
            setState(.loadedLibrary)
        }
        
        await setLibraryCache()
        //setState(.loadedLibrary)
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
