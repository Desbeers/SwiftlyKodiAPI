//
//  File.swift
//  
//
//  Created by Nick Berendsen on 08/03/2022.
//

import Foundation

extension KodiConnector {

    /// Get all songs from the Kodi host
    /// - Returns: All songs from the Kodi host
    func getAllSongs(albums: inout [MediaItem]) async -> [MediaItem] {
        /// Start with a fresh list
        var songItems = [MediaItem]()
        
        for (index, album) in albums.enumerated() {
            let songs = await getSongs(album: album)
            songItems += songs
        }
        return songItems
    }

    /// Get all songs from an album
    /// - Parameter album: The Album item
    /// - Returns: All songs from that album
    ///
    /// - Note: Don't ask for all songs from the library in one shot; it will timeout
    func getSongs(album: MediaItem) async -> [MediaItem] {
        let request = AudioLibraryGetSongs(albumID: album.albumID)
            do {
                let result = try await sendRequest(request: request)
                return setMediaItem(items: result.songs, media: .song)
            } catch {
                /// There are no artists in the library
                logger("Loading songs failed with error: \(error)")
                return [MediaItem]()
            }
    }
    
    /// Retrieve all songs from an album (Kodi API)
    struct AudioLibraryGetSongs: KodiAPI {
        /// AlbumID argument
        let albumID: Int
        /// Method
        let method = Method.audioLibraryGetSongs
        /// The JSON creator
        var parameters: Data {
            /// The parameters we ask for
            var params = Params()
            params.filter.albumid = albumID
            params.sort = sort(method: .track, order: .ascending)
            return buildParams(params: params)
        }
        /// The request struct
        struct Params: Encodable {
            let properties = [
                "title",
                "artist",
                "artistid",
                "comment",
                "year",
                "playcount",
                "albumid",
                "track",
                "disc",
                "lastplayed",
                "album",
                "genreid",
                "dateadded",
                "genre",
                "duration",
                "userrating"
            ]
            /// Sort order
            var sort = KodiConnector.SortFields()
            /// Filter
            var filter = Filter()
            /// The limits struct
            struct Filter: Encodable {
                /// The value for the filter
                var albumid: Int = 0
                /// The coding keys
                enum CodingKeys: String, CodingKey {
                    /// The key
                    case albumid
                }
            }
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of songs
            let songs: [KodiResponse]
        }
    }
}
