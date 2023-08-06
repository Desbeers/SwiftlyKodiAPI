//
//  KodiHost.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import SwiftUI
import SwiftlyStructCache

/// Host information to make a remote connection (SwiftlyKodi Type)
public struct HostItem: Codable, Identifiable, Hashable {
    /// The ID of the host
    public var id: String { ip }
    /// Name of the host
    public var name: String
    /// IP of the host
    public var ip: String
    /// Webserver port of the host
    public var port: Int
    /// TCP of the host
    /// - Note: This is found by `Bonjour` on first edit
    public var tcp: Int {
        if let host = KodiConnector.shared.bonjourHosts.first(where: { $0.ip == ip }) {
            return host.port
        }
        return 9090
    }
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

    /// Bool if the host is online
    public var isOnline: Bool {
        return bonjour == nil ? false : true
    }
    /// The optional `bonjour` result
    public var bonjour: KodiConnector.BonjourHost? {
        KodiConnector.shared.bonjourHosts.first { $0.name == name }
    }
    /// Content of the library
    /// - Note: Used as filter for notifications
    public var content: [Library.Media] {
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

    /// Bool if the host is selected
    public var isSelected: Bool {
        if KodiConnector.shared.host.ip == ip {
            return true
        }
        return false
    }

    @ViewBuilder var label: some View {
        Label(title: {
            Text(name)
        }, icon: {
            Image(systemName: status == .configured ? "globe" : "star.fill")
        })
    }

    /// Init the Host struct
    public init(
        name: String = "No Kodi connected",
        ip: String = "",
        port: Int = 8080,
        username: String = "",
        password: String = "",
        media: Media = .video,
        player: Player = .local,
        status: Status = .new
    ) {
        self.name = name
        self.ip = ip
        self.port = port
        self.username = username
        self.password = password
        self.media = media
        self.player = player
        self.status = status
    }

    /// The kind of media to load when connecting to the host
    /// - Note: Audio and Video both load Artists and Music Videos
    public enum Media: String, Codable {
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
    public enum Status: String, Codable {
        /// A new host
        case new
        /// A configured host
        case configured
    }

    /// The player the client want to use
    /// - Note: This will only influence Player status and Playlists updates
    public enum Player: String, Codable {
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
        logger("Save the selected host")
        do {
            try Cache.set(key: "SelectedHost", object: host)
        } catch {
            logger("Error saving selected host")
        }
    }

    /// Get the selected host
    /// - Returns: An optional ``HostItem``
    static func getSelectedHost() -> HostItem? {
        logger("Get the selected host")
        if let host = try? Cache.get(key: "SelectedHost", as: HostItem.self) {
            return host
        }
        /// No host selected
        return nil
    }

    /// Save all configured hosts to the cache
    /// - Parameter host: The selected host
    static func saveConfiguredHosts(hosts: [HostItem]) {
        logger("Save the configured hosts")
        do {
            try Cache.set(key: "ConfiguredHosts", object: hosts)
        } catch {
            logger("Error saving configured hosts")
        }
    }

    /// Get the configured hosts
    /// - Returns: An array ``HostItem``
    static func getConfiguredHosts() -> [HostItem] {
        logger("Get the configured hosts")
        if let hosts = try? Cache.get(key: "ConfiguredHosts", as: [HostItem].self) {
            return hosts
        }
        /// No host configured
        return []
    }
}
