//
//  Player+stop.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

// MARK: setShuffle

extension Player {

    /// Stops playback (Kodi API)
    /// - Parameter playerID: The ``Player/ID`` of the  player
    static func stop(playerID: Player.ID) {
        logger("Player.stop")
        KodiConnector.shared.sendMessage(message: Stop(playerID: playerID))
    }

    /// Stops playback (Kodi API)
    fileprivate struct Stop: KodiAPI {
        /// The ID of the player
        let playerID: Player.ID
        /// The method
        let method: Method = .playerStop
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
                /// Player ID
                case playerID = "playerid"
            }
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
