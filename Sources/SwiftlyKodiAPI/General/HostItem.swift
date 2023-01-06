//
//  KodiHost.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

/// Host information to make a remote connection (SwiftlyKodi Type)
public struct HostItem: Codable, Identifiable, Hashable {
    /// Give it an ID
    public var id: String { ip }
    /// Description of the host
    public var description: String? {
        if let host = KodiConnector.shared.bonjourHosts.first(where: {$0.ip == ip}) {
            return host.name
        }
        return nil
    }
    /// IP of the host
    public var ip: String
    /// Port of the host
    public var port: String
    /// TCP of the host
    public var tcp: String
    /// Username of the host
    public var username: String
    /// Password of the host
    public var password: String
    /// Kind of media to load
    public var media: Media

    /// Bool if the host is online

    public var isOnline: Bool {
        if KodiConnector.shared.bonjourHosts.first(where: {$0.ip == ip}) != nil {
            return true
        }
        return false
    }

    /// Init the Host struct
    public init(
        ip: String = "",
        port: String = "8080",
        tcp: String = "9090",
        username: String = "kodi",
        password: String = "kodi",
        media: Media = .video
    ) {
        self.ip = ip
        self.port = port
        self.tcp = tcp
        self.username = username
        self.password = password
        self.media = media
    }

    /// The kind of media to load when connecting to the host
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
}
