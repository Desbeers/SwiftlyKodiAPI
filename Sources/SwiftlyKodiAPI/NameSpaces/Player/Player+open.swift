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
        
        /// We need to wait on the result
        Task {
            let _ = try? await KodiConnector.shared.sendRequest(request: Open(shuffle: shuffle, playlistID: playlistID))
        }
        
        //KodiConnector.shared.sendMessage(message: Open(shuffle: shuffle, playlistID: playlistID))
    }
    
    public static func open(partyMode: Player.PartyMode) {
        logger("Player.open")
        //KodiConnector.shared.sendMessage(message: Open(partyMode: partyMode))
        
        /// We need to wait on the result
        Task {
            let _ = try? await KodiConnector.shared.sendRequest(request: Open(partyMode: partyMode))
        }
    }
    
    /// Start playback of either the playlist with the given ID, a slideshow with the pictures from the given directory or a single file or an item from the database (Kodi API)
    fileprivate struct Open: KodiAPI {
        /// The method
        let method: Methods = .playerOpen
        /// Shuffle or not
        var shuffle: Bool = false
        /// The optional playlist to play
        var playlistID: Playlist.ID? = nil
        /// The optional party mode
        var partyMode: Player.PartyMode? = nil
        /// The parameters
        var parameters: Data {
            var params = Params()
            
            if let playlistID = playlistID {
                params.item.playlistID = playlistID
                params.item.position = 0
            }
            
            if let partyMode = partyMode {
                params.item.partyMode = partyMode
            }
            params.options.shuffled = shuffle
            return buildParams(params: params)
        }
        /// The request struct
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
