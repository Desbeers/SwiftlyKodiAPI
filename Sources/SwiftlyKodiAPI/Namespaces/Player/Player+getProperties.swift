//
//  Player+getProperties.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

// MARK: getProperties

extension Player {

    /// Retrieves the properties of the player (Kodi API)
    /// - Parameter playerID: The ``Player/ID`` of the  player
    /// - Returns: The ``Player/Property/Value``
    public static func getProperties(playerID: Player.ID) async -> Player.Property.Value {
        logger("Player.getProperties")
        if let result = try? await KodiConnector.shared.sendRequest(request: GetProperties(playerID: playerID)) {
            return result
        } else {
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
