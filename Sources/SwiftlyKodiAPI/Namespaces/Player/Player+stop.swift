//
//  Player+stop.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: stop

extension Player {

    /// Stops playback (Kodi API)
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - playerID: The ``Player/ID`` of the player
    static func stop(host: HostItem, playerID: Player.ID) {
        JSON.sendMessage(message: Stop(host: host, playerID: playerID))
    }

    /// Stops playback (Kodi API)
    fileprivate struct Stop: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method: Method = .playerStop
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
                /// Player ID
                case playerID = "playerid"
            }
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
