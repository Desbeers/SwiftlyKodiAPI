//
//  Player+goTo.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK:  goTo

extension Player {
    
    /// Go to previous/next in the playlist (Kodi API)
    ///
    /// - Parameters:
    ///   - playerID: The ``Player/ID`` of the  player
    ///   - direction: The ``Player/GoToDirection``
    public static func goTo(playerID: Player.ID, direction: Player.GoToDirection) {
        KodiConnector.shared.sendMessage(message: GoTo(playerID: playerID, direction: direction))
    }
    
    /// Go to specific item in the playlist (Kodi API)
    ///
    /// - Parameters:
    ///   - playerID: The ``Player/ID`` of the  player
    ///   - position: The  ``Playlist/position`` in the playlist
    public static func goTo(playerID: Player.ID, position: Playlist.position) {
        KodiConnector.shared.sendMessage(message: GoTo(playerID: playerID, position: position))
    }
    
    /// Go to previous/next/specific item in the playlist (Kodi API)
    fileprivate struct GoTo: KodiAPI {
        /// The ID of the player
        let playerID: Player.ID
        /// The direction
        var direction: Player.GoToDirection? = nil
        /// The position
        var position: Playlist.position = 0
        /// The method
        let method: Methods = .playerGoTo
        /// The parameters
        var parameters: Data {
            if let direction = direction {
                return buildParams(params: Direction(playerID: playerID, direction: direction))
            }
            return buildParams(params: Position(playerID: playerID, position: position))
        }
        /// The request struct for an action
        struct Direction: Encodable {
            /// The player ID
            let playerID: Player.ID
            /// The direction
            let direction: Player.GoToDirection
            /// Coding keys
            enum CodingKeys: String, CodingKey {
                case playerID = "playerid"
                case direction = "to"
            }
        }
        /// The request struct for a position
        struct Position: Encodable {
            /// The player ID
            let playerID: Player.ID
            /// The position
            let position: Int
            /// Coding keys
            enum CodingKeys: String, CodingKey {
                case playerID = "playerid"
                case position = "to"
            }
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
