//
//  Websocket.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

extension KodiConnector {

    /// Connect the WebSocket
    /// - Note:
    ///     On iOS, disconnect before going to the background or else Apple will be really upset.
    func connectWebSocket() {
        // swiftlint:disable:next force_unwrapping
        let url = URL(string: "ws://\(host.ip):\(host.tcpPort)/jsonrpc")!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
        /// Recieve notifications
        receiveNotification()
    }

    /// Disconnect from the the Kodi WebSocket
    func disconnectWebSocket() {
        webSocketTask?.cancel(with: .normalClosure, reason: nil)
    }
}
