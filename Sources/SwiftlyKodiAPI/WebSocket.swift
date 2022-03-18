//
//  Websocket.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK: - WebSocket (Class)

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
        //let appState: AppState = .shared
        logger("Websocket connected to \(kodi.host.ip)")
        Task {
            await kodi.ping()
            await kodi.setState(current: kodi.state == .wakeup ? .loadedLibrary : .connectedToHost)
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
        logger("WebSocket disconnected from \(kodi.host.ip)")
    }
    
    /// Websocket notification when the connection has an error
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError: Error?) {
        if let error = didCompleteWithError {
            logger("Network error: \(error.localizedDescription)")
            //let appState: AppState = .shared
            let kodi: KodiConnector = .shared
            Task {
                await kodi.setState(current: .failure)
            }
        }
    }
}

extension KodiConnector {
    
    /// Connect the WebSocket
    /// - Note:
    ///     On iOS, disconnect before going to the background or else Apple will be really upset.
    ///     I use `@Environment(\.scenePhase)` to keep an eye on that
    func connectWebSocket() {
        //let appState: AppState = .shared
        let url = URL(string: "ws://\(host.ip):\(host.tcp)/jsonrpc")!
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
    
    /// Check if Kodi is still alive
    /// - Note: Failure will be handled by the delegate
    func ping() async {
        webSocketTask?.send(.string("ping")) { error in
        if let error = error {
            print("Error pinging host \(error.localizedDescription)")
        } else {
            Task {
                try await Task.sleep(nanoseconds: 5_000_000_000)
                await self.ping()
            }
        }
      }
    }
}
