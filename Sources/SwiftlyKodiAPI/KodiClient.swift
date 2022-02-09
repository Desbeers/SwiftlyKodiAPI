//
//  KodiClient.swift
//  Kodio
//
//  © 2021 Nick Berendsen
//

import Foundation

/// The KodiClient class
///
/// This class takes care of:
/// - Connecting to Kodi
/// - Checks the connection
/// - Sending JSON requests
/// - Receive notifications
public final class KodiClient {
    
    // MARK: Constants and Variables
    
    /// The shared instance of this KodiClient class
    public static let shared = KodiClient()
    /// The URL session
    let urlSession: URLSession
    /// The WebSocket task
    var webSocketTask: URLSessionWebSocketTask?
    /// Bool if we are scanning the libraray on a host
    var scanningLibrary = false
    
    /// The active host
    public var host = HostItem()
    
    // MARK: Init
    
    /// Private init to make sure we have only one instance
    private init() {
        /// Network stuff
        let configuration = URLSessionConfiguration.ephemeral
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 300
        configuration.timeoutIntervalForResource = 120
        self.urlSession = URLSession(configuration: configuration)
    }
//    /// Black magic
//    convenience init() {
//        self.init(configuration: .ephemeral)
//    }
}

/// The struct of a host item
public struct HostItem: Codable, Identifiable, Hashable {
    /// Give it an ID
    public var id = UUID()
    /// Description of the host
    var description: String = "UberMini"
    /// IP of the host
    /// var ip: String = "127.0.0.1"
    public var ip: String = "192.168.11.200"
    /// Port of the host
    var port: String = "8080"
    /// TCP of the host
    var tcp: String = "9090"
    /// Username of the host
    var username: String = "kodi"
    /// Password of the host
    var password: String = "kodi"
    /// Is this host selected?
    var selected: Bool = false
}
