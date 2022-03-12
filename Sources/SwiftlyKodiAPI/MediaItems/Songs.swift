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
        /// Use below for faster test loading; it will only load 100 albums
        /// for (index, album) in albums.enumerated() where album.albumID > 150 && album.albumID < 250 {
        for (index, album) in albums.enumerated() {
            var songs = await getSongsFromAlbum(album: album)
            /// Add some additional info to the songs
            for (index, song) in songs.enumerated() {
                songs[index].compilation = album.compilation
                songs[index].albumID = album.albumID
                /// Sometimes a song has a different poster than the album
                /// so let's use the album poster at all times
                songs[index].poster = album.poster
            }
            /// Add some additional information to the album
            albums[index].itemsCount = songs.count
            /// And now store it in the list
            songItems += songs
        }
        return songItems
    }

    /// Get all songs from an album
    /// - Parameter album: The Album item
    /// - Returns: All songs from that album
    ///
    /// - Note: Don't ask for all songs from the library in one shot; it will timeout
    func getSongsFromAlbum(album: MediaItem) async -> [MediaItem] {
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
    
    func setSongDetails(song: MediaItem) {
        
    }
    
    // MARK: Kodi API's
    
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
                "track",
                "disc",
                "lastplayed",
                "album",
                "genreid",
                "dateadded",
                "genre",
                "duration",
                "userrating",
                "file"
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
    
    /// Update the given song with the given details (Kodi API)
    struct AudioLibrarySetSongDetails: KodiAPI {
        /// Arguments
        var song: MediaItem
        /// Method
        var method = Method.audioLibrarySetSongDetails
        /// The JSON creator
        var parameters: Data {
            /// The parameters
            var params = Params()
            params.songid = song.songID
            params.userrating = song.rating
            params.playcount = song.playcount
            //params.lastplayed = song.lastPlayed
            return buildParams(params: params)
        }
        /// The request struct
        /// - Note: The properties we want to set
        struct Params: Encodable {
            /// The song ID
            var songid: Int = 0
            /// The rating of the song
            var userrating: Int = 0
            /// The play count of the song
            var playcount: Int = 0
            /// The last played date
            var lastplayed: String = ""
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
