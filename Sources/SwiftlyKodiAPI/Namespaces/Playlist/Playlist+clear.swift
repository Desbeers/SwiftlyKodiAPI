//
//  Playlist+clear.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: clear

extension Playlist {

    /// Clear playlist (Kodi API)
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - playlistID: The ``Playlist/ID`` of the player to clear
    public static func clear(host: HostItem, playlistID: Playlist.ID) {
        JSON.sendMessage(message: Clear(host: host, playlistID: playlistID))
    }

    /// Clear playlist (Kodi API)
    private struct Clear: KodiAPI {
        /// The host
        let host: HostItem
        /// The method to use
        let method = Method.playlistClear
        /// The playlist to clear
        let playlistID: Playlist.ID
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(playlistID: playlistID))
        }
        /// The parameters struct
        struct Params: Encodable {
            /// The ID of the playlist
            let playlistID: Playlist.ID
            /// Coding keys
            enum CodingKeys: String, CodingKey {
                /// The ID of the playlist
                case playlistID = "playlistid"
            }
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
