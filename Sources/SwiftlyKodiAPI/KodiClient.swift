//
//  KodiClient.swift
//  Kodio
//
//  © 2021 Nick Berendsen
//

import Foundation

/// The KodiClient class
///
/// This class takes care of:
/// - Connecting to Kodi
/// - Checks the connection
/// - Sending JSON requests
/// - Receive notifications
public final class KodiClient {
    
    // MARK: Constants and Variables
    
    /// The shared instance of this KodiClient class
    public static let shared = KodiClient()
    /// The URL session
    let urlSession: URLSession
    /// The WebSocket task
    var webSocketTask: URLSessionWebSocketTask?
    /// Bool if we are scanning the libraray on a host
    var scanningLibrary = false
    
    /// The active host
    public var host = HostItem()
    
    /// The VideoLibrary
    @Published var library: [KodiItem] = []

    /// The Genres
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
        
        Task {
            let libraryItems = await getAllVideos()
            library = libraryItems
            let genreItems = await getAllGenres()
            genres = genreItems
        }
    }
}

extension KodiClient {
    
    /// Get all the movies from the Kodi host
    /// - Returns: All the `MovieItem`'s from the Kodi host
    func getAllVideos() async -> [KodiItem] {
        var items: [KodiItem] = []
        await items += getMovies()
        let tvshows = await getTVshows()
        items += tvshows
        await items += getAllEpisodes(tvshows: tvshows)
        await items += getMusicVideos()
        return items
    }
    
    
    /// Set the kind of media for the ``KodiItem``
    ///
    /// A ``KodiItem`` can be of the following type:
    /// - Movie
    /// - TV show
    /// - Episode
    /// - Music Video
    ///
    /// - Parameters:
    ///   - item: The ``KodiItem``
    ///   - media: The ``KodiMedia`` type for this ``KodiItem``
    /// - Returns: The ``KodiItem``'s with the ``KodiMedia`` set
    func setMediaKind(items: [KodiItem], media: KodiMedia) -> [KodiItem] {
        var kodiItems: [KodiItem] = []
        for item in items {
            var newItem = item
            newItem.media = media
            kodiItems.append(newItem)
        }
        return kodiItems
    }
}
