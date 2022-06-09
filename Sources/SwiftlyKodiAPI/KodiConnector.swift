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
    /// The Meda Library from the remote host
    @Published public var media: [MediaItem] = []
    /// The currently selected `MediaItem`
    /// - Note: This package does not do anything with this; it is up to the Application to use it
    @Published public var selection: MediaItem?
    /// The general state of the KodiConnector bridge
    @Published var state: State = .none
    /// The loading state of the library
    @Published public var loadingState: loadingStatus = .start
    /// Notifications
    @Published public var notification = NotificationItem()
    /// ID of this Kodi Connector instance; used to send  notifications
    var kodiConnectorID = UUID().uuidString
    /// Debounce timer for saving the media library to the cache
    var cacheTimer: Timer?

    // MARK: Init
    
    /// Private init to make sure we have only one instance
    private init() {
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
                    await self.setState(current: .wakeup)
                }
            }
        }
#endif
    }
}

extension KodiConnector {
    

}
