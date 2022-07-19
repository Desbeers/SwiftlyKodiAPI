//
//  Player+open.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK:  open

extension Player {
    
    /// Start playback of either the playlist with the given ID, a slideshow with the pictures from the given directory or a single file or an item from the database (Kodi API)
    ///
    /// - Note: Only open a playlist is implemented
    ///
    /// - Parameters:
    ///   - playlistID: The ``Player/ID`` of the  player
    ///   - shuffle: Shuffle the playlist
    public static func open(playlistID: Playlist.ID, shuffle: Bool = false) {
        logger("Player.open")
        KodiConnector.shared.sendMessage(message: Open(shuffle: shuffle, playlistID: playlistID))
    }
    
    /// Start playback of either the playlist with the given ID, a slideshow with the pictures from the given directory or a single file or an item from the database (Kodi API)
    fileprivate struct Open: KodiAPI {
        /// The method
        let method: Methods = .playerOpen
        /// Shuffle or not
        var shuffle: Bool = false
        /// The playlist to play
        let playlistID: Playlist.ID
        /// The parameters
        var parameters: Data {
            var params = Params()
            params.item.playlistid = playlistID
            params.options.shuffled = shuffle
            return buildParams(params: params)
        }
        /// The request struct
        struct Params: Encodable {
            /// Item to open
            var item = Item()
            struct Item: Encodable {
                /// The playlist ID
                var playlistid: Playlist.ID = .audio
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
