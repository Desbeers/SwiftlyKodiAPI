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
