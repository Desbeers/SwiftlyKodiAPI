//
//  Playlist+getItems.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: getItems

extension Playlist {

    /// Get all items from playlist (Kodi API)
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - playlistID: The ``Playlist/ID`` of the playlist
    /// - Returns: All items in an ``KodiItem`` array
    public static func getItems(host: HostItem, playlistID: Playlist.ID) async -> [(any KodiItem)]? {
        Logger.library.info("Playlist.getItems (\(playlistID.rawValue))")
        var queue: [any KodiItem] = []
        let request = GetItems(host: host, playlistID: playlistID)
        do {
            let result = try await JSON.sendRequest(request: request)
            for item in result.items {
                /// If the result has an ID, it is from the library
                if let id = item.id, let item = await Application.getItem(host: host, type: item.type, id: id) {
                    queue.append(item)
                } else {
                    /// Return it as a stream item
                    queue.append(SwiftlyKodiAPI.Audio.Details
                        .Stream(
                            title: item.label,
                            subtitle: "Stream",
                            file: item.label
                        )
                    )
                }
            }
            return queue
        } catch {
            Logger.kodiAPI.error("Getting items from playlist failed with error: \(error)")
            return nil
        }
    }

    /// Get all items from playlist (Kodi API)
    fileprivate struct GetItems: KodiAPI {
        /// The host
        let host: HostItem
        /// The method to use
        let method = Method.playlistGetItems
        /// The ``Playlist/ID``
        let playlistID: Playlist.ID
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(playlistID: playlistID))
        }
        /// The parameters struct
        struct Params: Encodable {
            /// The playlist ID
            let playlistID: Playlist.ID
            /// Coding keys
            enum CodingKeys: String, CodingKey {
                /// The playlist ID
                case playlistID = "playlistid"
            }
        }
        /// The response struct
        struct Response: Decodable {
            /// The items in the queue
            let items: [QeueuItem]
        }
    }

    /// The struct for a queue item
    struct QeueuItem: Codable, Equatable {
        /// The item
        let id: Library.ID?
        let label: String
        var type: Library.Media = .none
    }
}
