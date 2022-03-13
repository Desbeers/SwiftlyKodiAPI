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

    /// Update the details of a song
    /// - Parameter song: The Media Item
    func setSongDetails(song: MediaItem) async {
        let message = AudioLibrarySetSongDetails(song: song)
        sendMessage(message: message)
        logger("Details set for '\(song.title)'")
    }
    
    /// Get the details of a song and update the media library
    /// - Parameters:
    ///   - songID: The ID of the song
    func getSongDetails(songID: Int) async -> MediaItem {
        let request = AudioLibraryGetSongDetails(songID: songID)
        do {
            let result = try await sendRequest(request: request)
            /// Make a MediaItem from the KodiResonse and return it
            return setMediaItem(items: [result.songdetails], media: .song).first ?? MediaItem()
        } catch {
            logger("Loading song details failed with error: \(error)")
            return MediaItem()
        }
    }
}

// MARK: Kodi API's

extension KodiConnector {
    
    /// The Song parameters we ask from Kodi
    static var SongProperties = [
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
            let properties = KodiConnector.SongProperties
            /// Sort order
            var sort = KodiConnector.SortFields()
            /// Filter
            var filter = Filter()
            /// The filter struct
            struct Filter: Encodable {
                /// The value for the filter
                var albumid: Int = 0
            }
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of songs
            let songs: [KodiResponse]
        }
    }
    
    /// Retrieve details about a specific song (Kodi API)
    struct AudioLibraryGetSongDetails: KodiAPI {
        /// Argument: the song we ask for
        var songID: Int
        /// Method
        var method = Method.audioLibraryGetSongDetails
        /// The JSON creator
        var parameters: Data {
            /// The parameters we ask for
            var params = Params()
            params.songid = songID
            return buildParams(params: params)
        }
        /// The request struct
        struct Params: Encodable {
            /// The properties that we ask from Kodi
            let properties = KodiConnector.SongProperties
            /// The ID of the song
            var songid: Int = 0
        }
        /// The response struct
        struct Response: Decodable {
            /// The details of the song
            var songdetails: KodiResponse
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
            let params = Params(song: song)
            return buildParams(params: params)
        }
        /// The request struct
        /// - Note: The properties we want to set
        struct Params: Encodable {
            internal init(song: MediaItem) {
                self.songid = song.songID
                self.userrating = song.rating
                self.playcount = song.playcount
                self.lastplayed = song.lastPlayed
            }
            /// The song ID
            var songid: Int
            /// The rating of the song
            var userrating: Int
            /// The play count of the song
            var playcount: Int
            /// The last played date
            var lastplayed: String
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
