//
//  KodiConnector+Status.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: Connection status

extension KodiConnector {

    /// Set the state of the KodiConnector and act on it
    @MainActor public func setStatus(_ current: Status, level: OSLogType = .info) {
        Logger.connection.log(level: level, "KodiConnector status: \(current.message)")
        //Logger.connection.info("KodiConnector status: \(current.message)")
        /// Set the current status
        status = current
        Task {
            statusAction(status: current)
        }
    }

    /// The status of the KodiConnector
    public enum Status {
        /// Not connected and no host
        case none
        /// Connected to the Kodi websocket
        case connectedToWebSocket
        /// Loading the library
        case loadingLibrary
        /// Updating the library
        case updatingLibrary
        /// The library is loaded
        case loadedLibrary
        /// The library is outdated
        case outdatedLibrary
        /// The device is sleeping
        case sleeping
        /// The device is waking up
        case wakeup
        /// The device is offline
        case offline
        /// The device came online
        case online
        /// An error when loading the library or a lost of connection
        case failure

        public var message: String {
            switch self {
            case .none:
                "Not connected to a Kodi"
            case .connectedToWebSocket:
                "Connected to the host"
            case .loadingLibrary:
                "Loading the library..."
            case .updatingLibrary:
                "Updating the library..."
            case .loadedLibrary:
                "Loaded the library"
            case .outdatedLibrary:
                "Library is outdated"
            case .sleeping:
                "Sleeping"
            case .wakeup:
                "Waking-up"
            case .offline:
                "The host is offline"
            case .online:
                "The host is online"
            case .failure:
                "Error"
            }
        }
    }

    /// The actions when the status of the KodiConnector is changed
    /// - Parameter status: the current ``Status``
    private func statusAction(status: Status) {
        switch status {

        case .online:
            makeConnection()
        case .connectedToWebSocket:
            Task {
                /// Get all List sortings
                listSortSettings = KodiListSort.getAllSortSettings(host: host)
                if host.media != .none {
                    await loadLibrary()
                }
                await getKodiState()
            }
        case .loadedLibrary:
            Task {
                await getUserPlaylists()
                if host.player == .local {
                    await getCurrentPlaylists()
                }
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
