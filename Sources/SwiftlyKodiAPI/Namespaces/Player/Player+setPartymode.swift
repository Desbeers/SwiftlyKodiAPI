//
//  Player+setPartyMode.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: setPartyMode

extension Player {

    /// Turn partymode on or off (Kodi API)
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - playerID: The ``Player/ID`` of the player
    static public func setPartyMode(host: HostItem, playerID: Player.ID) {
        JSON.sendMessage(message: SetPartyMode(host: host, playerID: playerID))
    }

    /// Turn partymode on or off (Kodi API)
    fileprivate struct SetPartyMode: KodiAPI {
        /// The host
        let host: HostItem
        /// The ID of the player
        let playerID: Player.ID
        /// The method
        let method: Method = .playerSetPartymode
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(playerid: playerID))
        }
        /// Params for SetPartyMode
        struct Params: Encodable {
            /// The player ID
            let playerid: Player.ID
            /// Toggle the party mode
            let partymode = "toggle"
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
