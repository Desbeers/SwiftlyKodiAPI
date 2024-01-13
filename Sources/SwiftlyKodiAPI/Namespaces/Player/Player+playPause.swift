//
//  Player+playPause.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: playPause

extension Player {

    /// Pauses or unpause playback of the player (Kodi API)
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - playerID: The ``Player/ID`` of the player
    /// - Note: When there is nothing in the player, this function will do nothing
    public static func playPause(host: HostItem, playerID: Player.ID) {
        JSON.sendMessage(message: PlayPause(host: host, playerID: playerID))
    }

    /// Pauses or unpause playback of the player (Kodi API)
    fileprivate struct PlayPause: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method: Method = .playerPlayPause
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(playerID: playerID))
        }
        /// The ID of the player
        let playerID: Player.ID
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
