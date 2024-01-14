//
//  Player+setRepeat.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: setRepeat

extension Player {

    /// Set the repeat mode of the player (Kodi API)
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - playerID: The ``Player/ID`` of the player
    static public func setRepeat(host: HostItem, playerID: Player.ID) {
        JSON.sendMessage(message: SetRepeat(host: host, playerID: playerID))
    }

    /// Set the repeat mode of the player (Kodi API)
    private struct SetRepeat: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method: Method = .playerSetRepeat
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(playerID: playerID))
        }
        /// The ID of the player
        let playerID: Player.ID
        /// The parameters struct
        struct Params: Encodable {
            /// The player ID
            let playerID: Player.ID
            /// Cycle trough repeating modus
            let repeating = "cycle"
            /// Coding keys
            enum CodingKeys: String, CodingKey {
                /// Player ID
                case playerID = "playerid"
                /// Repeat action
                case repeating = "repeat"
            }
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
