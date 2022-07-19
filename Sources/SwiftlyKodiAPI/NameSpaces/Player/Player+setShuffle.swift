//
//  Player+setShuffle.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Player {
    
    /// Shuffle/Unshuffle items in the player
    /// - Parameter playerID: The ID of the player
    static func setShuffle(playerID: Player.ID) {
        KodiConnector.shared.sendMessage(message: SetShuffle(playerID: playerID))
    }
    
    /// Shuffle/Unshuffle items in the player (Kodi API)
    struct SetShuffle: KodiAPI {
        /// The ID of the player
        let playerID: Player.ID
        /// The method
        let method: Methods = .playerSetShuffle
        /// The parameters
        var parameters: Data {
            /// Params for SetShuffle
            struct Parameters: Encodable {
                /// The player ID
                let playerid: Player.ID
                /// Toggle the shuffle
                let shuffle = "toggle"
            }
            return buildParams(params: Parameters(playerid: playerID))
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
