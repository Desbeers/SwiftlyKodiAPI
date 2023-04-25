//
//  KodiConnector.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import Network

/// The Observable Class that provides the connection with a remote host (SwiftlyKodi Type)
public final class KodiConnector: ObservableObject {

    // MARK: Constants and Variables

    /// The shared instance of this KodiConnector class
    public static let shared = KodiConnector()
    /// The URL session
    let urlSession: URLSession
    /// The WebSocket task
    var webSocketTask: URLSessionWebSocketTask?
    /// ID of this Kodi Connector instance; used to send  notifications
    var kodiConnectorID: String
    /// The host properties
    public var properties = Application.Property.Value()
    /// Bool if the host is scanning content
    /// - Note: Used to stop Notifications and Library updates or else the Host and the KodiConnector get nuts
    public var scanningLibrary: Bool = false
    /// Debounced tasks
    var task = Tasks()
    /// ZeroConf browser
    var browser: NWBrowser?

    // MARK: Published properties

    /// The status of the KodiConnector class
    @Published public var status: Status = .none

    /// The remote host to make a connection
    @Published public var host = HostItem()

    /// The library on the Kodi host
    @Published public var library = Library.Items()

    /// The host settings
    @Published public var settings: [Setting.Details.KodiSetting] = []

    /// The addons
    public var addons: [Addon.Details] = []

    /// The favourites
    @Published public var favourites: [any KodiItem] = []

    /// The online hosts
    @Published public var bonjourHosts: [BonjourHost] = []

    /// The configured hosts
    @Published public var configuredHosts: [HostItem]

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
        /// Get all configured hosts
        self.configuredHosts = HostItem.getConfiguredHosts()
        /// Get the optional selected host
        if let host = HostItem.getSelectedHost() {
            self.host = host
        }
        /// Start Bonjour to find Kodi hosts
        startBonjour()
        /// Sleeping and wakeup stuff
#if !os(macOS)
        NotificationCenter
            .default
            .addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { _ in
                logger("tvOS or iOS goes to the background")
                Task {
                    await self.setStatus(.sleeping)
                }
            }
        NotificationCenter
            .default
            .addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in
                logger("tvOS or iOS comes to the foreground")
                if self.status == .sleeping {
                    Task {
                        /// Set the state
                        await self.setStatus(.wakeup)
                    }
                }
            }
#else
        NSWorkspace
            .shared
            .notificationCenter
            .addObserver(forName: NSWorkspace.willSleepNotification, object: nil, queue: .main) { _ in
                logger("macOS goes to sleep")
                Task {
                    await self.setStatus(.sleeping)
                }
            }
        NSWorkspace
            .shared
            .notificationCenter
            .addObserver(forName: NSWorkspace.didWakeNotification, object: nil, queue: .main) { _ in
                logger("macOS wakes up")
                if self.status == .sleeping {
                    Task {
                        /// Set the status
                        await self.setStatus(.wakeup)
                    }
                }
            }
#endif
    }
}
