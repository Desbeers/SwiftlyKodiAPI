//
//  KodiConnector+State.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {

    /// Set the state of Kodio and act on it
    @MainActor func setState(current: State) {
        logger("KodiConnector status: \(current.rawValue)")
        state = current
        DispatchQueue.global(qos: .background).async {
            self.stateAction(state: current)
        }
    }
    
    /// The general status of the KodiConnector bridge
    enum State: String {
        /// Not connected and no host
        case none
        /// Connected to the Kodi host
        case connectedToHost
        /// Loading the library
        case loadingLibrary
        /// The library is  loaded
        case loadedLibrary
        /// The device is sleeping
        case sleeping
        /// The device is waking up
        case wakeup
        /// An error when loading the library or a lost of connection
        case failure
        /// KodiConnector has no host configuration
        case noHostConfig
    }

    /// Function that will run when the device is going to sleep
    func goSleeping() {
        disconnectWebSocket()
    }
    
    func doWakeup() {
        
    }
    
    /// The actions when the  state of Kodio is changed
    /// - Parameter state: the current ``State``
    private func stateAction(state: State) {
        switch state {

        case .sleeping:
            logger("App sleeping")
            disconnectWebSocket()
        case .wakeup:
            logger("App awake")
            connectWebSocket()
        default:
            break
        }
    }
}
