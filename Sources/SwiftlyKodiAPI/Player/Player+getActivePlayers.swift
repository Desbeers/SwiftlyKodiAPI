//
//  Player+getActivePlayers.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//
import Foundation

extension Player {
    
    /// Toggle the shuffle of the the current player
    static func getActivePlayers() async -> Int? {
        
        
        let request = GetActivePlayers()
        do {
            let result = try await KodiConnector.shared.sendRequest(request: request)
            if let activePlayer = result.first {
                print(activePlayer)
                return activePlayer.playerid
            } else {
                print("Nothing playing")
                return nil
            }
        } catch {
            print("Loading active player failed with error: \(error)")
            return nil
        }
        
        /// Struct for GetActivePlayers
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
}
