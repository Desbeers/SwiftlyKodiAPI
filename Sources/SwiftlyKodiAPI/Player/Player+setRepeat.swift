//
//  Player+setRepeat.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Player {
    
    /// Set the repeat mode of the player
    /// - Parameter playerID: The ID of the player
    static public func setRepeat(playerID: Player.ID) {
        KodiConnector.shared.sendMessage(message: SetRepeat(playerID: playerID))
    }
    
    /// Set the repeat mode of the player (Kodi API)
    struct SetRepeat: KodiAPI {
        /// The ID of the player
        let playerID: Player.ID
        /// The method
        let method: KodiConnector.Method = .playerSetRepeat
        /// The parameters
        var parameters: Data {
            /// Params for SetRepeat
            struct Params: Encodable {
                /// The player ID
                let playerid: Player.ID
                /// Cycle trough repeating modus
                let repeating = "cycle"
                /// Coding keys
                /// - Note: Repeat is a reserved word
                enum CodingKeys: String, CodingKey {
                    /// The key
                    case playerid
                    /// Repeat is a reserved word
                    case repeating = "repeat"
                }
            }
            return buildParams(params: Params(playerid: playerID))
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
