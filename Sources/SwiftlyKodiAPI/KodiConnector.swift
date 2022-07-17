//
//  KodiConnector.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import SwiftUI

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
    /// ID of this Kodi Connector instance; used to send  notifications
    var kodiConnectorID: String
    /// Debounce timer for saving the media library to the cache
    var cacheTimer: Timer?
    
    // MARK: Published properties

    /// The general state of the KodiConnector bridge
    @Published var state: State = .none
    /// The loading state of the library
    @Published public var loadingState: loadingStatus = .start
    /// Notifications
    public var notification = Notifications.Item()
    /// The state of the player
    @Published public var player = Player.Property.Value()
    /// The current item that is playing
    @Published public var currentItem: (any KodiItem)?
    /// The current items in the queue
    @Published public var queue: [(any KodiItem)]?
    /// Audio playlists
    @Published public var audioPlaylists: [List.Item.File] = []
    /// The host properties
    @Published public var properties = Application.Property.Value()
    
    // MARK: The library
    
    @Published public var library = MyLibrary()
    
    /// The library from the Kodi host
    public struct MyLibrary: Codable {
        /// The artist in your library
        public var artists: [Audio.Details.Artist] = []
        /// The albums in your library
        public var albums: [Audio.Details.Album] = []
        /// The songs in your library
        public var songs: [Audio.Details.Song] = []
        /// The audio genres in your library
        public var audioGenres: [Library.Details.Genre] = []
        /// The movies in your library
        public var movies: [Video.Details.Movie] = []
        /// The movie sets in your library
        public var movieSets: [Video.Details.MovieSet] = []
        /// The TV shows in your library
        public var tvshows: [Video.Details.TVShow] = []
        /// The TV show episodes in your library
        public var episodes: [Video.Details.Episode] = []
        /// The music videos in your library
        public var musicVideos: [Video.Details.MusicVideo] = []
        /// The video genres in your library
        public var videoGenres: [Library.Details.Genre] = []
    }
    
    // MARK: Init
    
    /// Private init to make sure we have only one instance
    private init() {
        /// Give this KodiConnector an unique ID
        kodiConnectorID = UUID().uuidString
        /// Network stuff
        let configuration = URLSessionConfiguration.ephemeral
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 300
        configuration.timeoutIntervalForResource = 120
        self.urlSession = URLSession(configuration: configuration)
        /// Sleeping and wakeup stuff
#if !os(macOS)
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { _ in
            logger("tvOS or iOS goes to the background")
            Task {
                await self.setState(current: .sleeping)
            }
        }
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in
            logger("tvOS or iOS comes to the foreground")
            if self.state == .sleeping {
                Task {
                    /// Get the state of the player
                    await self.getPlayerState()
                    await self.setState(current: .wakeup)
                }
            }
        }
#else
        NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.willSleepNotification, object: nil, queue: .main) { _ in
            logger("macOS goes to sleep")
            Task {
                await self.setState(current: .sleeping)
            }
        }
        NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.didWakeNotification, object: nil, queue: .main) { _ in
            logger("macOS wakes up")
            if self.state == .sleeping {
                Task {
                    /// Get the state of the player
                    //await self.getPlayerState()
                    await self.setState(current: .wakeup)
                }
            }
        }
#endif
    }
}

extension KodiConnector {
    

}
