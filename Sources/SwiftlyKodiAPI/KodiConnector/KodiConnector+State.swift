//
//  KodiConnector+State.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {

    /// Set the state of Kodio and act on it
    @MainActor public func setState(_ current: State) {
        logger("KodiConnector status: \(current.rawValue)")
        /// Set the current state
        state = current
        Task {
            stateAction(state: current)
        }
    }

    /// The state of the KodiConnector class
    public enum State: String {
        /// Not connected and no host
        case none = "Not connected to the host"
        /// Connected to the Kodi websocket
        case connectedToWebSocket = "Connected to the host"
        /// Loading the library
        case loadingLibrary = "Loading the library..."
        /// Updating the library
        case updatingLibrary = "Updating the library"
        /// The library is  loaded
        case loadedLibrary = "Loaded the library"
        /// The library is  outdated
        case outdatedLibrary = "Library is outdated"
        /// The device is sleeping
        case sleeping = "Sleeping"
        /// The device is waking up
        case wakeup = "Waking-up"
        /// The device is offline
        case offline = "The host is offline"
        /// The device icame online
        case online = "The host is online"
        /// An error when loading the library or a lost of connection
        case failure
    }

    /// The actions when the  state of Kodio is changed
    /// - Parameter state: the current ``State``
    private func stateAction(state: State) {
        switch state {

        case .online:
            makeConnection()
        case .connectedToWebSocket:
            Task {
                await getKodiState()
                await loadLibrary()
            }
        case .loadedLibrary:
            Task {
                await getCurrentPlaylists()
            }

        case .sleeping:
            disconnectWebSocket()
            stopBonjour()
        case .wakeup:
            startBonjour()
        default:
            break
        }
    }
}
