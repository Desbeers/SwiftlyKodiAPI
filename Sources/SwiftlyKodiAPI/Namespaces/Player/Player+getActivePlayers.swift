//
//  Player+getActivePlayers.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

// MARK: getActivePlayers

extension Player {

    /// Returns all active players, if any (Kodi API)
    /// - Returns: The active players in an ``Player/ID`` array
    public static func getActivePlayers() async -> [Player.ID]? {
        logger("Player.getActivePlayer")
        if let result = try? await KodiConnector.shared.sendRequest(request: GetActivePlayers()) {
            return result.map { $0.playerid}
        }
        return nil
    }

    /// Returns all active players (Kodi API)
    fileprivate struct GetActivePlayers: KodiAPI {
        let method: Method = .playerGetActivePlayers
        /// The parameters
        var parameters: Data {
            /// Params for GetActivePlayers (empty, no need)
            struct Params: Encodable { }
            return buildParams(params: Params())
        }
        /// The response struct
        typealias Response = [ActivePlayer]
        /// The response struct
        struct ActivePlayer: Decodable {
            let playerid: ID
            let playertype: String
            let type: MediaType
        }
    }
}
