//
//  Playlist+add.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Playlist {

    /// Add a stream to the playlist
    public static func add(stream: Audio.Details.Stream) async {
        let kodi: KodiConnector = .shared
        
        if let result = try? await kodi.sendRequest(request: Add(stream: stream)) {
            print("DONE")
        }
    }
    
    /// Add songs to the playlist
    public static func add(songs: [Audio.Details.Song]) async {
        let songs = songs.map({$0.songID})
        
        let kodi: KodiConnector = .shared
        
        if let result = try? await kodi.sendRequest(request: Add(songs: songs)) {
            print("DONE")
        }
    }
    
    /// Add item(s) to playlist (Kodi API)
    struct Add: KodiAPI {
        /// The method to use
        let method = Methods.playlistAdd
        
        /// List of optional song ID's
        var songs: [Int]?
        /// An optional stream item
        var stream: Audio.Details.Stream?
        
        /// The JSON creator
        var parameters: Data {
            /// # Add songs
            if let songs = songs {
                var params = Items()
                for song in songs {
                    params.item.append(Playlist.Item(songid: song))
                }
                return buildParams(params: params)
            }
            /// # Add stream
            if let stream = stream {
                var params = Item()
                params.item.file = stream.file
                return buildParams(params: params)
            }
            return Data()
        }
        /// The request struct for multiple items
        struct Items: Encodable {
            /// The array with playlist items
            var item = [Playlist.Item]()
            /// The ID of the playlist
            var playlistid = 0
        }
        /// The request struct for a single item
        struct Item: Encodable {
            /// The array with playlist items
            var item = Playlist.Item()
            /// The ID of the playlist
            var playlistid = 0
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
