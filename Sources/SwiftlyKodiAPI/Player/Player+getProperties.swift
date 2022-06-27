//
//  Player+getProperties.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Player {
    
    /// Retrieves the values of the given properties
    /// - Parameter playerID: The ID of the player
    /// - Returns: The values of the player properties
    static func getProperties(playerID: Player.ID) async -> Player.Property.Value {
        print(playerID)
        /// Retrieves the values of the given properties (Kodi API)
        struct GetProperties: KodiAPI {
            /// The ID of the player
            let playerID: Player.ID
            /// Method
            let method = KodiConnector.Method.playerGetProperties
            /// The JSON creator
            var parameters: Data {
                var params = Params()
                params.playerid = playerID.rawValue
                return buildParams(params: params)
            }
            /// The parameters struct
            struct Params: Encodable {
                /// The player ID
                var playerid = 0
                /// The properties we ask from Kodi
                let properties = Player.Property.name
            }
            /// The response struct
            typealias Response = Player.Property.Value
        }
        let request = GetProperties(playerID: playerID)
        do {
            let result = try await KodiConnector.shared.sendRequest(request: request)
            return result
        } catch {
            logger("Loading player properties failed with error: \(error)")
            return Player.Property.Value()
        }
    }
}

extension KodiConnector {
    
    /// Get the properties of the player
    func getPlayerProperties(playerID: Player.ID) async {
        let properties = await Player.getProperties(playerID: playerID)
        dump(properties)
        Task { @MainActor in
            playerProperties = properties
        }
    }
}
