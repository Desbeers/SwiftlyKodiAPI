//
//  Playlist+getItems.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK:  getItems

extension Playlist {
    
    /// Get all items from playlist (Kodi API)
    /// - Parameter playlistID: The ``Playlist/ID`` of the playlist
    /// - Returns: All items in an ``KodiItem`` array
    public static func getItems(playlistID: Playlist.ID) async -> [(any KodiItem)]? {
        logger("Playlist.getItems")
        var queue: [any KodiItem] = []
        
        let kodi: KodiConnector = .shared
        if let result = try? await kodi.sendRequest(request: GetItems(playlistID: playlistID)) {
            for item in result.items {
                /// If the result has an ID, it is from the library
                if let id = item.id, let item = await Library.getItem(type: item.type, id: id) {
                    queue.append(item)
//                    switch item.type {
//                    case .song:
//                        if let song = kodi.library.songs.first(where: {$0.songID == id}) {
//                            queue.append(song)
//                        }
//                    case .musicVideo:
//                        if let musicVideo = kodi.library.musicVideos.first(where: {$0.musicVideoID == id}) {
//                            queue.append(musicVideo)
//                        }
//                    case .movie:
//                        switch kodi.library.movies.count {
//                        case 0:
//                            queue.append(await VideoLibrary.getMovieDetails(movieID: id))
//                        default:
//                            if let musicVideo = kodi.library.musicVideos.first(where: {$0.musicVideoID == id}) {
//                                queue.append(musicVideo)
//                            }
//                        }
//                    default:
//                        break
//                    }
                } else {
                    /// Return it as a stream item
                    queue.append(SwiftlyKodiAPI.Audio.Details.Stream(title: item.label,
                                                                     subtitle: "Stream",
                                                                     file: item.label
                                                                    )
                    )
                }
            }
            if !queue.isEmpty {
                return queue
            }
        }
        return nil
    }
    
    /// Get all items from playlist (Kodi API)
    fileprivate struct GetItems: KodiAPI {
        /// The ``Playlist/ID``
        let playlistID: Playlist.ID
        /// The method to use
        let method = Methods.playlistGetItems
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
        let id: Library.id?
        let label: String
        var type: Library.Media = .none
    }
}
