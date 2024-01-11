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
    /// - Parameter playerID: The ``Player/ID`` of the  player
    /// - Returns: The ``Player/Property/Value``
    public static func getProperties(playerID: Player.ID) async -> Player.Property.Value {
        let kodi: KodiConnector = .shared
        let request = GetProperties(playerID: playerID)
        do {
            let result = try await kodi.sendRequest(request: request)
            Logger.player.info("Fetched player properties")
            return result
        } catch {
            Logger.player.error("Fetching player properties failed with error: \(error)")
            return Player.Property.Value()
        }
    }

    /// Retrieves the properties of the player (Kodi API)
    fileprivate struct GetProperties: KodiAPI {
        /// The player ID
        let playerID: Player.ID
        /// The method
        let method = Method.playerGetProperties
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(playerid: playerID))
        }
        /// The parameters struct
        struct Params: Encodable {
            /// The player ID
            let playerid: Player.ID
            /// The properties we ask from Kodi
            let properties = Player.Property.name
        }
        /// The response struct
        typealias Response = Player.Property.Value
    }
}
