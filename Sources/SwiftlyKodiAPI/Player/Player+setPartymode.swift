//
//  Player+setPartyMode.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Player {
    
    /// Turn partymode on or off
    /// - Parameter playerID: The ID of the player
    static public func setPartyMode(playerID: Player.ID = .audio) {
        KodiConnector.shared.sendMessage(message: SetPartyMode(playerID: playerID))
    }
    
    /// Turn partymode on or off(Kodi API)
    struct SetPartyMode: KodiAPI {
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
            var playerid: Player.ID
            /// Toggle the party mode
            let partymode = "toggle"
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
