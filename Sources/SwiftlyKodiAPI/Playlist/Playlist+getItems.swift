//
//  Playlist+getItems.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Playlist {
    
    /// Get all items from playlist
    public static func getItems() async -> [(any KodiItem)]? {
        
        var queue: [any KodiItem] = []
        
        let kodi: KodiConnector = .shared
        if let result = try? await kodi.sendRequest(request: GetItems()) {
            
            for item in result.items {
                /// If the result has an ID, it is from the library
                if let id = item.id {
                    
                    switch item.type {
                    case .song:
                        if let song = kodi.library.songs.first(where: {$0.songID == id}) {
                            queue.append(song)
                        }
                    default:
                        break
                    }
                    
                }
            }
            return queue
        }
        return nil
    }
    
    /// Get all items from playlist (Kodi API)
    struct GetItems: KodiAPI {
        /// The method to use
        let method = Methods.playlistGetItems
        /// The JSON creator
        var parameters: Data {
            return buildParams(params: Params())
        }
        /// The request struct
        struct Params: Encodable {
            /// The playlist ID
            let playlistid = 0
        }
        /// The response struct
        struct Response: Decodable {
            /// The items in the queue
            let items: [QueueItem]
        }
    }
    
    /// The struct for a queue item
    struct QueueItem: Codable, Equatable {
        /// The item
        let id: Int?
        var type: Library.Media = .none
//        /// Coding keys
//        enum CodingKeys: String, CodingKey {
//            /// ID is a reserved word
//            case songID = "id"
//        }
    }
}
