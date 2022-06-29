//
//  Player+getItem.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Player {
    
    /// Retrieves the currently played item
    /// - Parameter playerID: The ``ID`` of the current player
    /// - Returns: The current ``MediaItem``
    public static func getItem(playerID: Player.ID) async -> MediaItem {
        
        if let result = try? await KodiConnector.shared.sendRequest(request: GetItem(playerID: playerID)) {
            /// If the result has an ID, it is from the library
            if let id = result.item.id, let libraryItem = KodiConnector.shared.media.filter({ $0.id == "\(result.item.type)-\(id)"}) .first {
                return libraryItem
            } else {
                return MediaItem(title: result.item.label)
            }
        } else {
            return MediaItem()
        }
    }
    
    /// Retrieves the currently played item (Kodi API)
    struct GetItem: KodiAPI {
        let playerID: Player.ID
        /// Method
        let method = Methods.playerGetItem
        /// The JSON creator
        var parameters: Data {
            return buildParams(params: Params(playerid: playerID.rawValue))
        }
        /// The request struct
        struct Params: Encodable {
            /// The player ID
            let playerid: Int
        }
        /// The response struct
        struct Response: Decodable {
            /// The item in the player
            var item = PlayerItem()
        }
        /// The current player item
        struct PlayerItem: Decodable {
            var id: Int?
            var label: String = ""
            var type: String = ""
        }
    }
}
