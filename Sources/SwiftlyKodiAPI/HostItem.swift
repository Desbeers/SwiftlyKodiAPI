//
//  KodiHost.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

/// The struct for host information to make a remote connection
public struct HostItem: Codable, Identifiable, Hashable {
    /// Give it an ID
    public var id: UUID
    /// Description of the host
    public var description: String
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
    public var media: Files.Media
    /// Init the Host struct
    public init(id: UUID = UUID(),
                description: String = "Kodi",
                ip: String = "192.168.11.200",
                port: String = "8080",
                tcp: String = "9090",
                username: String = "kodi",
                password: String = "kodi",
                media: Files.Media = .video
    ) {
        self.id = id
        self.description = description
        self.ip = ip
        self.port = port
        self.tcp = tcp
        self.username = username
        self.password = password
        self.media = media
    }
    
//    public enum Media: String, Codable {
//        /// The audio library
//        case audio
//        /// The video library
//        case video
//        /// The whole library
//        case all
//    }
}
