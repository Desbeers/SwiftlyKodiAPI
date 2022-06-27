//
//  Player+playPause.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Player {
    
    /// Play/pause the current player
    static func playPause() {
        /// Struct for Play/Pause
        struct PlayPause: KodiAPI {
            let method: KodiConnector.Method = .playerPlayPause
            /// The JSON creator
            var parameters: Data {
                /// Struct for Play/Pause
                struct Parameters: Encodable {
                    /// The player ID
                    let playerid = 0
                }
                return buildParams(params: Parameters())
            }
            /// The response struct
            struct Response: Decodable { }
        }
        KodiConnector.shared.sendMessage(message: PlayPause())
    }
}
