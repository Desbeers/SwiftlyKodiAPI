//
//  Player+goTo.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Player {
    
    /// Go to previous/next/specific item in the playlist
    /// - Parameter playerID: The ID of the player
    static func goTo(playerID: Player.ID = .audio, action: Player.GoToAction) async {
        KodiConnector.shared.sendMessage(message: GoTo(playerID: playerID, action: action))
    }
    
    /// Go to previous/next/specific item in the playlist (Kodi API)
    struct GoTo: KodiAPI {
        /// The ID of the player
        let playerID: Player.ID
        /// The action
        let action: Player.GoToAction
        /// The method
        let method: Methods = .playerGoTo
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(playerID: playerID, action: action))
        }
        /// Params struct for GoTo
        struct Params: Encodable {
            /// The player ID
            let playerID: Player.ID
            /// The action
            let action: Player.GoToAction
            /// Coding keys
            enum CodingKeys: String, CodingKey {
                case playerID = "playerid"
                case action = "to"
            }
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
