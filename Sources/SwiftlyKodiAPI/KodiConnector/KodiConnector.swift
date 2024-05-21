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
@Observable
public final class KodiConnector: @unchecked Sendable {

    // MARK: Constants and Variables

    /// The WebSocket task
    var webSocketTask: URLSessionWebSocketTask?
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
    public var listSortSettings: [SwiftlyKodiAPI.List.Sort] = []

    // MARK: Published properties

    /// The current host of the ``KodiConnector``
    public private(set) var host = HostItem(ip: "", port: 8080, tcpPort: 9090)

    /// The status of the KodiConnector connection
    public private(set) var status: Status = .none

    /// The library on the Kodi host
    public var library = Library.Items()

    /// The host settings
    public var settings: [Setting.Details.Setting] = []

    /// The addons
    public var addons: [Addon.Details] = []

    /// The favourites
    public var favourites: [AnyKodiItem] = []

    /// The online hosts
    public var bonjourHosts: [HostItem] = []

    /// The configured hosts
    public var configuredHosts: [HostItem]

    /// The Kodi Player
    public var player: KodiPlayer = KodiPlayer()

    // MARK: Init

    /// Init the KodiConnector
    public init() {
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

// MARK: Setters

extension KodiConnector {
    
    /// Set the current host
    @MainActor
    public func setHost(_ host: HostItem) {
        Logger.connection.log("Set '\(host.name)' as the current host")
        self.host = host
    }

    /// Set the status of the KodiConnector and act on it
    @MainActor
    public func setStatus(_ current: Status, level: OSLogType = .info) {
        Logger.connection.log(level: level, "KodiConnector status: \(current.message)")
        /// Set the current status
        status = current
        Task {
            await statusAction(status: current)
        }
    }
}
