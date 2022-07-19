//
//  Playlist+clear.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Playlist {
    
    /// Clear playlist (Kodi API)
    /// - Parameter playlistID: The ``Playlist/ID`` of the player to clear
    public static func clear(playlistID: Playlist.ID) async {
        KodiConnector.shared.sendMessage(message: Clear(playlistID: playlistID))
    }
    
    /// Clear playlist (Kodi API)
    fileprivate struct Clear: KodiAPI {
        /// The method to use
        let method = Methods.playlistClear
        /// The playlist to clear
        let playlistID: Playlist.ID
        /// The JSON creator
        var parameters: Data {
            buildParams(params: Params(playlistid: playlistID))
        }
        /// The request struct
        struct Params: Encodable {
            /// The ID of the playlist
            let playlistid: Playlist.ID
        }
        /// The response struct
        struct Response: Decodable { }
    }
}