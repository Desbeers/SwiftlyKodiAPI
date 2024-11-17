//
//  KodiHost.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import OSLog

/// Host information to make a remote connection (SwiftlyKodi Type)
public struct HostItem: Codable, Identifiable, Hashable, Sendable {

    /// Init the HostItem struct
    public init(
        name: String = Bundle.main.clientName,
        ip: String,
        port: Int,
        tcpPort: Int,
        username: String = "",
        password: String = "",
        media: Media = .video,
        player: Player = .local,
        status: Status = .new
    ) {
        self.name = name
        self.ip = ip
        self.port = port
        self.tcpPort = tcpPort
        self.username = username
        self.password = password
        self.media = media
        self.player = player
        self.status = status
    }

    /// The ID of the host
    public var id: String { ip }
    /// Name of the host
    public var name: String
    /// IP of the host
    public var ip: String
    /// Webserver port of the host
    public var port: Int
    /// TCP port of the host
    public var tcpPort: Int
    /// Username of the host
    public var username: String
    /// Password of the host
    public var password: String
    /// Kind of media to load
    public var media: Media
    /// Kind of player to use
    public var player: Player
    /// Status of the host
    public var status: Status
    /// Content of the library
    /// - Note: Used as filter for notifications
    public var libraryContent: [Library.Media] {
        switch media {
        case .audio:
            return [.none, .artist, .album, .song, .genre, .musicVideo]
        case .video:
            return [.none, .movie, .movieSet, .tvshow, .episode, .genre, .artist, .musicVideo]
        case .all:
            return Library.Media.allCases
        case .none:
            return []
        }
    }

    // MARK: Enums for host options

    /// The kind of media to load when connecting to the host
    /// - Note: Audio and Video both load Artists and Music Videos
    public enum Media: String, Codable, Sendable {
        /// Load the audio library
        case audio
        /// Load the video library
        case video
        /// Load the whole library
        case all
        /// Don't load the library
        case none
    }

    /// The status of the host
    public enum Status: String, Codable, Sendable {
        /// A new host
        case new
        /// A configured host
        case configured
    }

    /// The player the client want to use
    /// - Note: This will only influence Player status and Playlists updates
    public enum Player: String, Codable, Sendable {
        /// Use the local player
        case local
        /// Use a custom player
        case stream
    }
}

extension HostItem {

    /// Save the selected host to the cache
    /// - Parameter host: The selected ``HostItem``
    static func saveSelectedHost(host: HostItem) {
        do {
            try Cache.set(key: "SelectedHost", object: host)
        } catch {
            Logger.connection.error("Error saving selected host")
        }
    }

    /// Get the selected host
    /// - Returns: An optional ``HostItem``
    static func getSelectedHost() -> HostItem? {
        if let host = try? Cache.get(key: "SelectedHost", as: HostItem.self) {
            Logger.connection.info("'\(host.name)' is the selected host")
            return host
        }
        /// No host selected
        Logger.connection.warning("There is no host selected")
        return nil
    }

    /// Save all configured hosts to the cache
    /// - Parameter host: The selected host
    static func saveConfiguredHosts(hosts: [HostItem]) {
        do {
            try Cache.set(key: "ConfiguredHosts", object: hosts)
        } catch {
            Logger.connection.error("Error saving the configured hosts")
        }
    }

    /// Get the configured hosts
    /// - Returns: An array ``HostItem``
    static func getConfiguredHosts() -> [HostItem] {
        if let hosts = try? Cache.get(key: "ConfiguredHosts", as: [HostItem].self) {
            let hostCount = hosts.count
            Logger.connection.info("\(hostCount) configured \(hostCount == 1 ? "host" : "hosts") found")
            return hosts
        }
        /// No host configured
        Logger.connection.warning("There is no host configured")
        return []
    }
}
