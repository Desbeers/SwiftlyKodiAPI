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

    /// The VideoLibrary
    @Published public var library: [KodiItem] = [] {
        
        willSet {
            print("Library willSet an update!")
        }
        
        didSet {
            print("Library didSet an update!")
        }
    }

    /// All genres from the Kodi library
    @Published public var genres: [GenreItem] = []
    
    /// All artists from the Kodi library
    @Published public var artists: [KodiItem] = []
    
    /// Private library stuff
    
    @Published public var movies: [KodiItem] = []

    
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
            let libraryItems = await getAllVideos()
            library = libraryItems
            let genreItems = await getAllGenres()
            genres = genreItems
            let artistItems = await getArtists()
            artists = artistItems
        }
    }

    /// Reload the library from the Kodi host
    @MainActor public func reloadHost() {
        /// Empty the library
        library = [KodiItem]()
        /// Reload it
        connectToHost(kodiHost: host)
    }
}

extension KodiConnector {
    
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
        var KodiItems: [KodiItem] = []
        for item in items {
            var newItem = item
            newItem.media = media
            KodiItems.append(newItem)
        }
        return KodiItems
    }
}
