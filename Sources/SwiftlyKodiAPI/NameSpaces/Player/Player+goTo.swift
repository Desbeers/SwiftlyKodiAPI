//
//  Player+goTo.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK:  goTo

extension Player {
    
    /// Go to previous/next/specific item in the playlist (Kodi API)
    ///
    /// - Note: Specific item not implemented yet
    ///
    /// - Parameters:
    ///   - playerID: The ``Player/ID`` of the  player
    ///   - action: The ``Player/GoToAction``
    public static func goTo(playerID: Player.ID, action: Player.GoToAction) {
        KodiConnector.shared.sendMessage(message: GoTo(playerID: playerID, action: action))
    }
    
    /// Go to previous/next/specific item in the playlist (Kodi API)
    fileprivate struct GoTo: KodiAPI {
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
        /// The request struct
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
