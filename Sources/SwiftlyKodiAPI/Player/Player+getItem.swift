//
//  Player+getItem.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Player {
    
    static func getItem() async -> MediaItem {
        /// Fallback
        let item = MediaItem()
        
        let request = GetItem()
        do {
            let result = try await KodiConnector.shared.sendRequest(request: request)
            
            if let libraryItem = KodiConnector.shared.media.filter({ $0.id == "\(result.item.type)-\(result.item.id)"}) .first {
                return libraryItem
            }
            return item
        } catch {
            print("Loading player item failed with error: \(error)")
            return item
        }
        
        /// Retrieves the currently played item (Kodi API)
        struct GetItem: KodiAPI {
            /// Method
            var method = KodiConnector.Method.playerGetItem
            /// The JSON creator
            var parameters: Data {
                return buildParams(params: GetItem())
            }
            /// The request struct
            struct GetItem: Encodable {
                /// The player ID
                let playerid = 0
                /// The properties we ask for
                //let properties = PlayerItem().properties
            }
            /// The response struct
            struct Response: Decodable {
                /// The item in the player
                var item = PlayerItem()
            }
            /// The current player item
            struct PlayerItem: Decodable {
                var id: Int = 0
                var type: String = ""
            }
        }
        
    }
}

extension KodiConnector {
    
    /// Get the current item of the player
    func getPlayerItem(playerID: Player.ID) async {
        let item = await Player.getItem()
        Task { @MainActor in
            currentItem = item
        }
    }
}
