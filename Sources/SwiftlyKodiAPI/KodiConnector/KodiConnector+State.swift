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
                
                if host.media == .audio {
                    await getAudioLibraryUpdates()
                }
            }
        default:
            break
        }
    }
}
