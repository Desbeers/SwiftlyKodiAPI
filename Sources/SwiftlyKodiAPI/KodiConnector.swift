//
//  KodiConnector.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

/// The Class that provides the connection between Swift and the Kodi host
public final class KodiConnector: ObservableObject {
    
    // MARK: Constants and Variables
    
    /// The shared instance of this KodiConnector class
    public static let shared = KodiConnector()
    /// The URL session
    let urlSession: URLSession
    /// The WebSocket task
    var webSocketTask: URLSessionWebSocketTask?
    
    /// The active host
    var host = HostItem()

    /// The Meda Library
    @Published public var media: [MediaItem] = []

    /// All genres from the Kodi library
    @Published public var genres: [GenreItem] = []

    
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
    public func connectToHost(kodiHost: HostItem) {
        host = kodiHost
        Task { @MainActor in
            let libraryItems = await getAllMedia()
            media = libraryItems
            let genreItems = await getAllGenres()
            genres = genreItems
        }
    }

    /// Reload the library from the Kodi host
    @MainActor public func reloadHost() {
        /// Empty the library
        media = [MediaItem]()
        /// Reload it
        connectToHost(kodiHost: host)
    }
}

extension KodiConnector {
    
    /// Get all the movies from the Kodi host
    /// - Returns: All the `MovieItem`'s from the Kodi host
    func getAllMedia() async -> [MediaItem] {
        var items: [MediaItem] = []
        let movieSets = await getMovieSets()
        items += movieSets
        await items += getMovies()
        let tvshows = await getTVshows()
        items += tvshows
        await items += getAllEpisodes(tvshows: tvshows)
        await items += getMusicVideos()
        
        await items += getArtists()
        
        return items
    }
}
