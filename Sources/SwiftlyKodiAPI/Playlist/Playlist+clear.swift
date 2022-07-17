//
//  Playlist+clear.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Playlist {
    
    /// Clear playlist
    public static func clear() async {
        let kodi: KodiConnector = .shared
        kodi.sendMessage(message: Clear())
    }
    
    /// Clear playlist(Kodi API)
    struct Clear: KodiAPI {
        /// The method to use
        let method = Methods.playlistClear
        /// The JSON creator
        var parameters: Data {
            buildParams(params: Params())
        }
        /// The request struct
        struct Params: Encodable {
            /// The ID of the playlist
            let playlistid = 0
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
