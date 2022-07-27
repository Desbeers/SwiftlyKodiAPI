//
//  KodiConnector.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// The Class that provides the connection with a remote host (SwiftlyKodi Type)
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
    /// Debounced tasks
    var task = Tasks()
    
    // MARK: Published properties

    /// The state of the KodiConnector class
    @Published public var state: State = .none
    /// The state of the player
    @Published public var player = Player.State()
    /// The host properties
    @Published public var properties = Application.Property.Value()
    /// The library on the Kodi host
    @Published public var library = Library.Items()
    
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
                await self.setState(.sleeping)
            }
        }
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in
            logger("tvOS or iOS comes to the foreground")
            if self.state == .sleeping {
                Task {
                    /// Get the state of the player
                    await self.getPlayerState()
                    await self.setState(.wakeup)
                }
            }
        }
#else
        NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.willSleepNotification, object: nil, queue: .main) { _ in
            logger("macOS goes to sleep")
            Task {
                await self.setState(.sleeping)
            }
        }
        NSWorkspace.shared.notificationCenter.addObserver(forName: NSWorkspace.didWakeNotification, object: nil, queue: .main) { _ in
            logger("macOS wakes up")
            if self.state == .sleeping {
                Task {
                    /// Get the state of the player
                    //await self.getPlayerState()
                    await self.setState(.wakeup)
                }
            }
        }
#endif
    }
}
