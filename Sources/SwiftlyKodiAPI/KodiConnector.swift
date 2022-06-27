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
    
    /// The Meda Library from the remote host
    @Published public var media: [MediaItem] = []
    /// The currently selected `MediaItem`
    /// - Note: This package does not do anything with this; it is up to the Application to use it
    //@Published public var selection: MediaItem?
    /// The general state of the KodiConnector bridge
    @Published var state: State = .none
    /// The loading state of the library
    @Published public var loadingState: loadingStatus = .start
    /// Notifications
    //@Published public var notification = NotificationItem()
    /// The state of the player
    @Published public var playerProperties = Player.Property.Value()
    /// The current item that is playing
    @Published public var currentItem = MediaItem()
    /// The playlist queue
    @Published public var queue: [MediaItem] = []

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
                    /// Get the properties of the player
                    await self.getPlayerProperties(playerID: .audio)
                    await self.getPlayerItem(playerID: .audio)
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
                    /// Get the properties of the player
                    await self.getPlayerProperties(playerID: .audio)
                    await self.getPlayerItem(playerID: .audio)
                    await self.setState(current: .wakeup)
                }
            }
        }
#endif
    }
}

extension KodiConnector {
    

}
