//
//  Player+goTo.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

// MARK: goTo

extension Player {

    /// Go to previous/next in the playlist (Kodi API)
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - playerID: The ``Player/ID`` of the player
    ///   - direction: The ``Player/GoToDirection``
    public static func goTo(host: HostItem, playerID: Player.ID, direction: Player.GoToDirection) {
        JSON.sendMessage(message: GoTo(host: host, playerID: playerID, direction: direction))
    }

    /// Go to specific item in the playlist (Kodi API)
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - playerID: The ``Player/ID`` of the player
    ///   - position: The ``Playlist/position`` in the playlist
    public static func goTo(host: HostItem, playerID: Player.ID, position: Playlist.position) {
        JSON.sendMessage(message: GoTo(host: host, playerID: playerID, position: position))
    }

    /// Go to previous/next/specific item in the playlist (Kodi API)
    private struct GoTo: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method: Method = .playerGoTo
        /// The parameters
        var parameters: Data {
            if let direction = direction {
                return buildParams(params: Direction(playerID: playerID, direction: direction))
            }
            return buildParams(params: Position(playerID: playerID, position: position))
        }
        /// The ID of the player
        let playerID: Player.ID
        /// The direction
        var direction: Player.GoToDirection?
        /// The position
        var position: Playlist.position = 0
        /// The parameters struct for an action
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
        /// The parameters struct for a position
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
