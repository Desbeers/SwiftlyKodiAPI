//
//  Playlist+add.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK:  add

extension Playlist {

    /// Add a stream to the playlist (Kodi API)
    /// - Parameter stream: The ``Audio/Details/Stream`` item
    public static func add(stream: Audio.Details.Stream) async {
        /// Get the shared KodiConnector
        let kodi: KodiConnector = .shared
        /// We need to wait on the result
        let _ = try? await kodi.sendRequest(request: Add(stream: stream))
    }
    
    /// Add songs to the playlist (Kodi API)
    /// - Parameter songs: An array of ``Audio/Details/Song`` items
    public static func add(songs: [Audio.Details.Song]) async {
        /// Map the song ID's
        let songs = songs.map({$0.songID})
        /// Get the shared KodiConnector
        let kodi: KodiConnector = .shared
        /// We need to wait on the result
        let _ = try? await kodi.sendRequest(request: Add(songs: songs))
    }
    
    /// Add music videos to the playlist (Kodi API)
    /// - Parameter musicVideos: An array of ``Video/Details/MusicVideo`` items
    public static func add(musicVideos: [Video.Details.MusicVideo]) async {
        /// Map the music video ID's
        let musicVideos = musicVideos.map({$0.musicVideoID})
        /// Get the shared KodiConnector
        let kodi: KodiConnector = .shared
        /// We need to wait on the result
        let _ = try? await kodi.sendRequest(request: Add(musicVideos: musicVideos))
    }
    
    /// Add item(s) to playlist (Kodi API)
    fileprivate struct Add: KodiAPI {
        /// The method to use
        let method = Methods.playlistAdd
        /// List of optional song ID's
        var songs: [Int]?
        /// List of optional music video ID's
        var musicVideos: [Int]?
        /// An optional stream item
        var stream: Audio.Details.Stream?
        /// The JSON creator
        var parameters: Data {
            logger("Playlist.add")
            var params = Params()
            /// # Add songs
            if let songs = songs {
                params.playlistID = .audio
                for song in songs {
                    params.item.append(Playlist.Item(songid: song))
                }
            }
            /// # Add music videos
            if let musicVideos = musicVideos {
                params.playlistID = .video
                for musicVideo in musicVideos {
                    params.item.append(Playlist.Item(musicvideoid: musicVideo))
                }
            }
            /// # Add a stream
            if let stream = stream {
                params.playlistID = .audio
                params.item.append(Playlist.Item(file: stream.file))
            }
            return buildParams(params: params)
        }
        /// The parameters struct
        struct Params: Encodable {
            /// The array with playlist items
            var item = [Playlist.Item]()
            /// The ID of the playlist
            var playlistID: Playlist.ID = .audio
            /// Coding keys
            enum CodingKeys: String, CodingKey {
                case item
                case playlistID = "playlistid"
            }
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
