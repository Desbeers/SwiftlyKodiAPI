//
//  Player+playPause.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Player {
    
    /// Pauses or unpause playback of the player
    /// - Parameter playerID: The ID of the player
    public static func playPause(playerID: Player.ID) {
        KodiConnector.shared.sendMessage(message: PlayPause(playerID: playerID))
    }
    
    /// Pauses or unpause playback of the player (Kodi API
    struct PlayPause: KodiAPI {
        /// The ID of the player
        let playerID: Player.ID
        /// The method
        let method: KodiConnector.Method = .playerPlayPause
        /// The parameters
        var parameters: Data {
            /// Params for PlayPause
            struct Params: Encodable {
                /// The player ID
                let playerid: Player.ID
            }
            return buildParams(params: Params(playerid: playerID))
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
