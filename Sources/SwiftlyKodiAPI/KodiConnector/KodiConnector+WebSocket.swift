//
//  Websocket.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: WebSocket (Class)

/// The Delegate for the WebSocket connection
///
/// - This will be called when connecting/disconnecting to the socket and when there is an error
class WebSocket: NSObject, URLSessionWebSocketDelegate {
    /// Websocket notification when the connection starts
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didOpenWithProtocol protocol: String?
    ) {
        let kodi: KodiConnector = .shared
        Task {
            await kodi.setStatus(.connectedToWebSocket)
        }
    }

    /// Websocket notification when the connection stops
    func urlSession(
        _ session: URLSession,
        webSocketTask: URLSessionWebSocketTask,
        didCloseWith closeCode: URLSessionWebSocketTask.CloseCode,
        reason: Data?
    ) {
        let kodi: KodiConnector = .shared
        Logger.connection.warning("WebSocket disconnected from \(kodi.host.ip)")
    }

    /// Websocket notification when the connection has an error
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError: Error?) {
        let kodi: KodiConnector = .shared
        if let error = didCompleteWithError, kodi.status != .offline {
            Logger.connection.error("Network error: \(error.localizedDescription)")
            Task {
                await kodi.setStatus(.offline, level: .fault)
            }
        }
    }
}

extension KodiConnector {

    /// Connect the WebSocket
    /// - Note:
    ///     On iOS, disconnect before going to the background or else Apple will be really upset.
    func connectWebSocket() {
        // swiftlint:disable:next force_unwrapping
        let url = URL(string: "ws://\(host.ip):\(host.tcpPort)/jsonrpc")!
        let webSocketDelegate = WebSocket()
        let session = URLSession(configuration: .default, delegate: webSocketDelegate, delegateQueue: OperationQueue())
        webSocketTask = session.webSocketTask(with: url)
        webSocketTask?.resume()
        /// Recieve notifications
        receiveNotification()
    }

    /// Disconnect from the the Kodi WebSocket
    func disconnectWebSocket() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
    }
}
