//
//  Player+getActivePlayers.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//
import Foundation

extension Player {
    
    /// Get the active player (if any)
    static func getActivePlayers() async -> Player.ID? {
        
        if let result = try? await KodiConnector.shared.sendRequest(request: GetActivePlayers()),
           let activePlayer = result.first {
            return Player.ID(rawValue: activePlayer.playerid)
        }
        return nil
    }
    
    /// Returns all active players (Kodi API)
    struct GetActivePlayers: KodiAPI {
        let method: KodiConnector.Method = .playerGetActivePlayers
        /// The JSON creator
        var parameters: Data {
            /// Struct for GetActivePlayers (empty, no need)
            struct Parameters: Encodable { }
            return buildParams(params: Parameters())
        }
        typealias Response = [ActivePlayer]
        /// The response struct
        struct ActivePlayer: Decodable {
            var playerid: Int
            var playertype: String
            var type: String
        }
    }
}
