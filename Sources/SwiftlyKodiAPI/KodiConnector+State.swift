//
//  KodiConnector+State.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {

    /// Set the state of Kodio and act on it
    @MainActor func setState(_ current: State) {
        logger("KodiConnector status: \(current.rawValue)")
        state = current
        Task {
            stateAction(state: current)
        }
    }
    
    /// The state of the KodiConnector class
    public enum State: String {
        /// Not connected and no host
        case none
        /// Connected to the Kodi websocket
        case connectedToWebSocket = "Connected to the websocket"
        /// Loading the library
        case loadingLibrary = "Loading the library"
        /// The library is  loaded
        case loadedLibrary = "Loaded the library"
        /// The device is sleeping
        case sleeping = "The device is going to sleep"
        /// The device is waking up
        case wakeup = "The device is waking-up"
        /// An error when loading the library or a lost of connection
        case failure
        /// KodiConnector has no host configuration
        case noHostConfig
    }
    
    /// The actions when the  state of Kodio is changed
    /// - Parameter state: the current ``State``
    private func stateAction(state: State) {
        switch state {
        case .sleeping:
            disconnectWebSocket()
        case .wakeup:
            connectWebSocket()
            Task {
                await getPlayerState()
                await getCurrentPlaylist()
            }
        default:
            break
        }
    }
}
