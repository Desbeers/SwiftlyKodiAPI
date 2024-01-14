//
//  Player+getProperties.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: getProperties

extension Player {

    /// Retrieves the properties of the player (Kodi API)
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - playerID: The ``Player/ID`` of the player
    /// - Returns: The ``Player/Property/Value``
    public static func getProperties(host: HostItem, playerID: Player.ID) async -> Player.Property.Value {
        let request = GetProperties(host: host, playerID: playerID)
        do {
            let result = try await JSON.sendRequest(request: request)
            Logger.player.info("Retrieved player properties")
            return result
        } catch {
            Logger.player.error("Fetching player properties failed with error: \(error)")
            return Player.Property.Value()
        }
    }

    /// Retrieves the properties of the player (Kodi API)
    private struct GetProperties: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method = Method.playerGetProperties
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(playerID: playerID))
        }
        /// The player ID
        let playerID: Player.ID
        /// The parameters struct
        struct Params: Encodable {
            /// The player ID
            let playerID: Player.ID
            /// The properties we ask from Kodi
            let properties = Player.Property.name
            /// Coding keys
            enum CodingKeys: String, CodingKey {
                case playerID = "playerid"
                case properties
            }
        }
        /// The response struct
        typealias Response = Player.Property.Value
    }
}
