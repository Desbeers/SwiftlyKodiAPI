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
    /// - Returns: The current ``KodiItem``
    public static func getItem(playerID: Player.ID) async -> (any KodiItem)? {
        logger("Player.getItem")
        let kodi: KodiConnector = .shared
        if let result = try? await kodi.sendRequest(request: GetItem(playerID: playerID)) {
            /// If the result has an ID, it is from the library
            if let id = result.item.id {
                switch result.item.type {
                case .song:
                    return await AudioLibrary.getSongDetails(songID: id)
                case .musicVideo:
                    return await VideoLibrary.getMusicVideoDetails(musicVideoID: id)
                default:
                    logger("Unknown item in the player")
                }
            } else {
                /// Return it as a stream item
                return SwiftlyKodiAPI.Audio.Details.Stream(title: result.item.label,
                                                           subtitle: result.item.artist?.first ?? "Streaming",
                                                           file: result.item.mediapath
                )
            }
        }
        return nil
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
            var properties = ["title", "artist", "mediapath"]
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
            var title: String = ""
            var artist: [String]?
            var mediapath: String = ""
            //var type: String = ""
            var type: Library.Media = .none
        }
    }
}