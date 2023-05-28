//
//  Player+getItem.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

// MARK: getItem

extension Player {

    /// Retrieves the currently played item (Kodi API)
    ///
    /// If the result has an ID, it is from the Library and media details will be asked
    ///
    /// - Note: This method does not depend on a 'loaded library'
    ///
    /// - Parameter playerID: The ``Player/ID`` of the  player
    /// - Returns: a ``KodiItem`` if there is a current item
    public static func getItem(playerID: Player.ID) async -> (any KodiItem)? {
        logger("Player.getItem")
        let kodi: KodiConnector = .shared
        if let result = try? await kodi.sendRequest(request: GetItem(playerID: playerID)) {
            /// If the result has an ID, it is from the library
            if let id = result.item.id, let item = await Application.getItem(type: result.item.type, id: id) {
                return item
            } else {
                /// Return it as a stream item
                return SwiftlyKodiAPI.Audio.Details.Stream(
                    title: result.item.label,
                    subtitle: result.item.artist?.first ?? "Streaming",
                    file: result.item.mediapath
                )
            }
        }
        /// Nothing is playing
        return nil
    }

    /// Retrieves the currently played item (Kodi API)
    fileprivate struct GetItem: KodiAPI {
        /// The ``Player/ID``
        let playerID: Player.ID
        /// The method
        let method = Method.playerGetItem
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(playerID: playerID))
        }
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
