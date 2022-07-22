//
//  Player+setRepeat.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK:  setRepeat

extension Player {
    
    /// Set the repeat mode of the player (Kodi API)
    /// - Parameter playerID: The ``Player/ID`` of the  player
    static public func setRepeat(playerID: Player.ID) {
        logger("Player.setRepeat")
        KodiConnector.shared.sendMessage(message: SetRepeat(playerID: playerID))
    }
    
    /// Set the repeat mode of the player (Kodi API)
    fileprivate struct SetRepeat: KodiAPI {
        /// The ID of the player
        let playerID: Player.ID
        /// The method
        let method: Methods = .playerSetRepeat
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(playerID: playerID))
        }
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
