//
//  Player+getActivePlayers.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//
import Foundation

extension Player {
    
    /// Get the active players (if any)
    public static func getActivePlayers() async -> [ID]? {
        
        if let result = try? await KodiConnector.shared.sendRequest(request: GetActivePlayers()) {
            //dump(result)
            return result.map { $0.playerid}
        }
        return nil
    }
    
    /// Returns all active players (Kodi API)
    struct GetActivePlayers: KodiAPI {
        let method: Methods = .playerGetActivePlayers
        /// The JSON creator
        var parameters: Data {
            /// Params for GetActivePlayers (empty, no need)
            struct Parameters: Encodable { }
            return buildParams(params: Parameters())
        }
        typealias Response = [ActivePlayer]
        /// The response struct
        struct ActivePlayer: Decodable {
            var playerid: ID
            var playertype: String
            var type: Kind
        }
    }
}
