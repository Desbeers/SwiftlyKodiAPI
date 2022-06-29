//
//  Player+getProperties.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Player {
    
    /// Retrieves the values of the given properties
    /// - Parameter playerID: The ID of the player
    /// - Returns: The values of the player properties
    public static func getProperties(playerID: Player.ID) async -> Player.Property.Value {
        if let result = try? await KodiConnector.shared.sendRequest(request: GetProperties(playerID: playerID)) {
            return result
        } else {
            return Player.Property.Value()
        }
    }
    
    /// Retrieves the values of the given properties (Kodi API)
    struct GetProperties: KodiAPI {
        /// The ID of the player
        let playerID: Player.ID
        /// Method
        let method = KodiConnector.Method.playerGetProperties
        /// The JSON creator
        var parameters: Data {
            return buildParams(params: Params(playerid: playerID.rawValue))
        }
        /// The parameters struct
        struct Params: Encodable {
            /// The player ID
            var playerid: Int
            /// The properties we ask from Kodi
            let properties = Player.Property.name
        }
        /// The response struct
        typealias Response = Player.Property.Value
    }
}

//extension KodiConnector {
//    
//    /// Get the properties of the player
//    @MainActor func getPlayerProperties(playerID: Player.ID) async {
//        
//        var properties = Player.Property.Value()
//        
//        if let playerID = await Player.getActivePlayers() {
//            properties = await Player.getProperties(playerID: playerID.rawValue)
//            //dump(properties)
//        } else {
//            logger("Player is not playing")
//        }
//        playerProperties = properties
//    }
//}
