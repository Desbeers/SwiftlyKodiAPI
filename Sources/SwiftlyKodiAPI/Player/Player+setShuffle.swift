//
//  Player+setShuffle.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Player {
    
    /// Shuffle/Unshuffle items in the player
    static func setShuffle() {
        KodiConnector.shared.sendMessage(message: SetShuffle())
    }
    
    /// Shuffle/Unshuffle items in the player (Kodi API)
    struct SetShuffle: KodiAPI {
        let method: KodiConnector.Method = .playerSetShuffle
        /// The JSON creator
        var parameters: Data {
            /// Struct for SetShuffle
            struct Parameters: Encodable {
                /// The player ID
                let playerid = 0
                /// Toggle the shuffle
                let shuffle = "toggle"
            }
                return buildParams(params: Parameters())
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
