//
//  KodiConnector+State.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

extension KodiConnector {

    /// Set the state of Kodio and act on it
    @MainActor public func setState(_ current: State) {
        logger("KodiConnector status: \(current.message)")
        /// Set the current state
        state = current
        Task {
            stateAction(state: current)
        }
    }

    /// The state of the KodiConnector class
    public enum State {
        /// Not connected and no host
        case none
        /// Connected to the Kodi websocket
        case connectedToWebSocket
        /// Loading the library
        case loadingLibrary
        /// Updating the library
        case updatingLibrary
        /// The library is  loaded
        case loadedLibrary
        /// The library is  outdated
        case outdatedLibrary
        /// The device is sleeping
        case sleeping
        /// The device is waking up
        case wakeup
        /// The device is offline
        case offline
        /// The device icame online
        case online
        /// An error when loading the library or a lost of connection
        case failure

        public var message: String {

            let host = KodiConnector.shared.host.name

            switch self {

            case .none:
                return "Not connected to a Kodi"
            case .connectedToWebSocket:
                return "Connected to the host"
            case .loadingLibrary:
                return "Loading the library..."
            case .updatingLibrary:
                return "Updating the library..."
            case .loadedLibrary:
                return "Loaded the library"
            case .outdatedLibrary:
                return "Library is outdated"
            case .sleeping:
                return "Sleeping"
            case .wakeup:
                return "Waking-up"
            case .offline:
                return "\(host) is offline"
            case .online:
                return "\(host) is online"
            case .failure:
                return "Error"
            }
        }
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
