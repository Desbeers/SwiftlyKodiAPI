//
//  Player+open.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: open

extension Player {

    /// Start playback of a playlist with the given ID (Kodi API)
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - playlistID: The ``Playlist/ID`` of the playlist
    ///   - shuffle: Shuffle the playlist
    public static func open(host: HostItem, playlistID: Playlist.ID, shuffle: Bool = false) {
        JSON.sendMessage(message: Open(host: host, shuffle: shuffle, playlistID: playlistID))
    }

    /// Start playback in party mode (Kodi API)
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - partyMode: The ``Player/PartyMode``
    public static func open(host: HostItem, partyMode: Player.PartyMode) {
        JSON.sendMessage(message: Open(host: host, partyMode: partyMode))
    }

    /// Start playback of either the playlist with the given ID,
    /// a slideshow with the pictures from the given directory
    /// or a single file or an item from the database (Kodi API)
    fileprivate struct Open: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method: Method = .playerOpen
        /// The parameters
        var parameters: Data {
            var params = Params()

            if let playlistID {
                params.item.playlistID = playlistID
                params.item.position = 0
            }

            if let partyMode {
                params.item.partyMode = partyMode
            }
            params.options.shuffled = shuffle
            return buildParams(params: params)
        }
        /// Shuffle or not
        var shuffle: Bool = false
        /// The optional playlist to play
        var playlistID: Playlist.ID?
        /// The optional party mode
        var partyMode: Player.PartyMode?

        /// The parameters struct
        struct Params: Encodable {
            /// Item to open
            var item = Item()
            struct Item: Encodable {
                /// The playlist ID
                var playlistID: Playlist.ID?
                /// Position in the playlist
                var position: Int?
                /// The party mode
                var partyMode: Player.PartyMode?
                /// Coding keys
                enum CodingKeys: String, CodingKey {
                    case playlistID = "playlistid"
                    case partyMode = "partymode"
                    case position
                }
            }
            /// Options for Open
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
