//
//  Player+playPause.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Player {
    
    /// Start playback of either the playlist with the given ID, a slideshow with the pictures from the given directory or a single file or an item from the database
    public static func open(shuffle: Bool = false) async {
        KodiConnector.shared.sendMessage(message: Open(shuffle: shuffle))
    }
    
    /// Start playback of either the playlist with the given ID, a slideshow with the pictures from the given directory or a single file or an item from the database (Kodi API)
    struct Open: KodiAPI {
        /// The method
        let method: Methods = .playerOpen
        /// Shuffle or not
        var shuffle: Bool = false
        /// The parameters
        var parameters: Data {
            var params = OpenPlaylist()
            params.options.shuffled = shuffle
            return buildParams(params: params)
        }
        /// Struct for OpenPlaylist
        struct OpenPlaylist: Encodable {
            /// Item to open
            var item = Item()
            struct Item: Encodable {
                /// The playlist ID
                var playlistid = 0
                /// Position in the playlist
                var position = 0
            }
            /// Options for OpenPlaylist
            var options = Options()
            /// The struct for options
            struct Options: Encodable {
                /// Shuffle or not
                var shuffled = false
            }
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
