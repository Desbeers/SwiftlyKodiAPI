//
//  Player+setPartyMode.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK: setPartyMode

extension Player {

    /// Turn partymode on or off (Kodi API)
    /// - Parameter playerID: The ``Player/ID`` of the  player
    static public func setPartyMode(playerID: Player.ID) {
        logger("Player.setPartyMode")
        KodiConnector.shared.sendMessage(message: SetPartyMode(playerID: playerID))
    }

    /// Turn partymode on or off (Kodi API)
    fileprivate struct SetPartyMode: KodiAPI {
        /// The ID of the player
        let playerID: Player.ID
        /// The method
        let method: Methods = .playerSetPartymode
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
