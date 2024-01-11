//
//  KodiConnector.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import Network
import OSLog

/// The Observable Class that provides the connection with a remote host (SwiftlyKodi Type)
@Observable public final class KodiConnector {

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
    /// The settings to sort a list of Kodi items
    var listSortSettings: [SwiftlyKodiAPI.List.Sort] = []

    // MARK: Published properties

    /// The status of the KodiConnector class
    public var status: Status = .none

    /// The remote host to make a connection
    public var host = HostItem()

    /// The library on the Kodi host
    public var library = Library.Items()

    /// The host settings
    public var settings: [Setting.Details.KodiSetting] = []

    /// The addons
    public var addons: [Addon.Details] = []

    /// The favourites
    public var favourites: [AnyKodiItem] = []

    /// The online hosts
    public var bonjourHosts: [BonjourHost] = []

    /// The configured hosts
    public var configuredHosts: [HostItem]

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
        /// Start Bonjour to find Kodi hosts
        startBonjour()
        /// Sleeping and wakeup stuff
#if !os(macOS)
        NotificationCenter
            .default
            .addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { _ in
                Logger.connection.notice("tvOS or iOS goes to the background")
                Task {
                    await self.setStatus(.sleeping)
                }
            }
        NotificationCenter
            .default
            .addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { _ in
                Logger.connection.notice("tvOS or iOS comes to the foreground")
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
                Logger.connection.notice("macOS goes to sleep")
                Task {
                    await self.setStatus(.sleeping)
                }
            }
        NSWorkspace
            .shared
            .notificationCenter
            .addObserver(forName: NSWorkspace.didWakeNotification, object: nil, queue: .main) { _ in
                Logger.connection.notice("macOS wakes up")
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
