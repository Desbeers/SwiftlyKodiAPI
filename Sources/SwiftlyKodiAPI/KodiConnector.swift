//
//  KodiConnector.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

/// The Class that provides the connection between Swift and the remote host
public final class KodiConnector: ObservableObject {
    
    // MARK: Constants and Variables
    
    /// The shared instance of this KodiConnector class
    public static let shared = KodiConnector()
    /// The URL session
    let urlSession: URLSession
    /// The WebSocket task
    var webSocketTask: URLSessionWebSocketTask?
    /// The remote host to make a connection
    var host = HostItem()
    /// The Meda Library from the remote host
    @Published public var media: [MediaItem] = []

    // MARK: Init
    
    /// Private init to make sure we have only one instance
    private init() {
        /// Network stuff
        let configuration = URLSessionConfiguration.ephemeral
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 300
        configuration.timeoutIntervalForResource = 120
        self.urlSession = URLSession(configuration: configuration)
    }
}

extension KodiConnector {
    
    /// Connect to a Kodi host and load the library
    /// - Parameter kodiHost: The host configuration
    @MainActor public func connectToHost(kodiHost: HostItem) async {
        host = kodiHost
        let libraryItems = await getAllMedia()
        logger("Loaded the library")
        media = libraryItems
        //let genreItems = await getAllGenres()
        //genres = genreItems
    }
    
    /// Reload the library from the Kodi host
    @MainActor public func reloadHost() async {
        logger("Reloading the library")
        /// Empty the library
        media = [MediaItem]()
        /// Reload it
        await connectToHost(kodiHost: host)
    }
}

extension KodiConnector {
    
    /// Get all media from the Kodi host library
    /// - Returns: All the media from the Kodi host library
    func getAllMedia() async -> [MediaItem] {
        var items: [MediaItem] = []
        await items += getMovies()
        var tvshows = await getTVshows()
        /// - Note: The ``getAllEpisodes`` function will add info to the TV show items
        await items += getAllEpisodes(tvshows: &tvshows)
        /// Now we can store the TV shows in the `items` array
        items += tvshows
        await items += getMusicVideos()
        await items += getArtists()
        await items += getAllGenres()
        /// That's all!
        return items
    }
}
