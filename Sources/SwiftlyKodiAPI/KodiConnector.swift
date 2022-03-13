//
//  KodiConnector.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation
#if os(tvOS)
import UIKit
#endif

/// The Class that provides the connection between Swift and the remote host
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
    /// The Meda Library from the remote host
    @Published public var media: [MediaItem] = []
    /// The general state of the KodiConnector bridge
    @Published var state: State = .none
    /// The loading state of the library
    @Published public var loadingState: loadingStatus = .start
    /// Notifications
    @Published public var notification = NotificationItem()
    /// ID of this Kodi Connector instance; used to send  notifications
    var kodiConnectorID = UUID().uuidString
    /// Debounce timer for saving the media library to the cache
    var cacheTimer: Timer?

    // MARK: Init
    
    /// Private init to make sure we have only one instance
    private init() {
        /// Network stuff
        let configuration = URLSessionConfiguration.ephemeral
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 300
        configuration.timeoutIntervalForResource = 120
        self.urlSession = URLSession(configuration: configuration)
        /// Sleeping and wakeup stuff for tvOS and iOS
#if !os(macOS)
        NotificationCenter.default.addObserver(forName: UIApplication.didEnterBackgroundNotification, object: nil, queue: .main) { [unowned self] notification in
            logger("tvOS or iOS goes to the background")
        }
        NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] notification in
            logger("tvOS or iOS comes to the foreground")
        }
#endif
    }
}

extension KodiConnector {
    

}
