//
//  Player+getItem.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: getItem

extension Player {

    /// Retrieves the currently played item (Kodi API)
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - playerID: The ``Player/ID`` of the player
    /// - Returns: a ``KodiItem`` if there is a current item
    ///
    /// If the result has an ID, it is from the Library and media details will be asked
    public static func getItem(host: HostItem, playerID: Player.ID) async -> (any KodiItem)? {
        let request = GetItem(host: host, playerID: playerID)
        do {
            let result = try await JSON.sendRequest(request: request)
            Logger.player.info("Playing '\(result.item.title)'")
            /// If the result has an ID, it is from the library
            if let id = result.item.id, let item = await Application.getItem(host: host, type: result.item.type, id: id) {
                return item
            } else {
                /// Return it as a stream item
                return SwiftlyKodiAPI.Audio.Details.Stream(
                    title: result.item.label,
                    subtitle: result.item.artist?.first ?? "Streaming",
                    file: result.item.mediapath
                )
            }
        } catch {
            Logger.kodiAPI.error("Fetching player item with error: \(error)")
            return nil
        }
    }

    /// Retrieves the currently played item (Kodi API)
    fileprivate struct GetItem: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method = Method.playerGetItem
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(playerID: playerID))
        }
        /// The ``Player/ID``
        let playerID: Player.ID
        /// The parameters struct
        struct Params: Encodable {
            /// The properties we ask for
            let properties = ["title", "artist", "mediapath"]
            /// The player ID
            let playerID: Player.ID
            /// Coding keys
            enum CodingKeys: String, CodingKey {
                case properties
                case playerID = "playerid"
            }
        }
        /// The response struct
        struct Response: Decodable {
            /// The item in the player
            let item: PlayerItem
        }
        /// The current player item
        struct PlayerItem: Decodable {
            let id: Library.ID?
            let label: String
            let title: String
            let artist: [String]?
            let mediapath: String
            let type: Library.Media
        }
    }
}
