//
//  Player+playPause.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK:  playPause

extension Player {
    
    /// Pauses or unpause playback of the player (Kodi API)
    ///
    /// - Note: When there is nothing in the player, this function will do nothing
    ///
    /// - Parameter playerID: The ``Player/ID`` of the  player
    public static func playPause(playerID: Player.ID) {
        logger("Player.playPause")
        KodiConnector.shared.sendMessage(message: PlayPause(playerID: playerID))
    }
    
    /// Pauses or unpause playback of the player (Kodi API)
    fileprivate struct PlayPause: KodiAPI {
        /// The ID of the player
        let playerID: Player.ID
        /// The method
        let method: Methods = .playerPlayPause
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(playerID: playerID))
        }
        /// The parameters struct
        struct Params: Encodable {
            /// The player ID
            let playerID: Player.ID
            /// Coding keys
            enum CodingKeys: String, CodingKey {
                /// The player ID
                case playerID = "playerid"
            }
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
