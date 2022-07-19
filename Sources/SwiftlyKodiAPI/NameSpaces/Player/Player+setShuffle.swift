//
//  Player+setShuffle.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK:  setShuffle

extension Player {
    
    /// Shuffle/Unshuffle items in the player (Kodi API)
    /// - Parameter playerID: The ``Player/ID`` of the  player
    static func setShuffle(playerID: Player.ID) {
        logger("Player.setShuffle")
        KodiConnector.shared.sendMessage(message: SetShuffle(playerID: playerID))
    }
    
    /// Shuffle/Unshuffle items in the player (Kodi API)
    fileprivate struct SetShuffle: KodiAPI {
        /// The ID of the player
        let playerID: Player.ID
        /// The method
        let method: Methods = .playerSetShuffle
        /// The parameters
        var parameters: Data {
            buildParams(params: Parameters(playerID: playerID))
        }
        /// The request struct
        struct Parameters: Encodable {
            /// The player ID
            let playerID: Player.ID
            /// Toggle the shuffle
            let shuffle = "toggle"
            /// Coding keys
            enum CodingKeys: String, CodingKey {
                /// Player ID
                case playerID = "playerid"
                /// Shuffle action
                case shuffle
            }
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
