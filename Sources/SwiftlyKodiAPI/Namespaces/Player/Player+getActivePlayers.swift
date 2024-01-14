//
//  Player+getActivePlayers.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: getActivePlayers

extension Player {

    /// Returns all active players, if any (Kodi API)
    /// - Parameter host: The ``HostItem`` for the request
    /// - Returns: The active players in an ``Player/ID`` array
    public static func getActivePlayers(host: HostItem) async -> [Player.ID]? {
        let request = GetActivePlayers(host: host)
        do {
            let result = try await JSON.sendRequest(request: request)
            if result.isEmpty {
                Logger.player.info("There is no player active at the moment")
            } else {
                Logger.player.info("Current player: \(result.map(\.type.rawValue).joined())")
            }
            return result.map(\.playerID)
        } catch {
            Logger.kodiAPI.error("Fetching active players failed with error: \(error)")
            return nil
        }
    }

    /// Returns all active players (Kodi API)
    private struct GetActivePlayers: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
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
            let playerID: ID
            let playerType: String
            let type: MediaType

            enum CodingKeys: String, CodingKey {
                case playerID = "playerid"
                case playerType = "playertype"
                case type
            }
        }
    }
}
