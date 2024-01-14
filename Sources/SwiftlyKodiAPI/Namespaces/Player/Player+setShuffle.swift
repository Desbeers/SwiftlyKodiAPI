//
//  Player+setShuffle.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: setShuffle

extension Player {

    /// Shuffle/Unshuffle items in the player (Kodi API)
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - playerID: The ``Player/ID`` of the player
    static func setShuffle(host: HostItem, playerID: Player.ID) {
        JSON.sendMessage(message: SetShuffle(host: host, playerID: playerID))
    }

    /// Shuffle/Unshuffle items in the player (Kodi API)
    private struct SetShuffle: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method: Method = .playerSetShuffle
        /// The parameters
        var parameters: Data {
            buildParams(params: Parameters(playerID: playerID))
        }
        /// The ID of the player
        let playerID: Player.ID
        /// The parameters struct
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
