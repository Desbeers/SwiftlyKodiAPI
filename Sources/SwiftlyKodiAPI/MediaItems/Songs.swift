//
//  Songs.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension AudioLibrary {
    static func getSongsTest(
        filter: List.Filter? = nil,
        sort: List.Sort = List.Sort(method: .track, order: .ascending),
        limits: List.Limits? = nil
    ) async {
        let kodi: KodiConnector = .shared
        if let request = try? await kodi.sendRequest(request: GetSongsTest(filter: filter, limits: limits, sort: sort)) {
            logger("Loaded \(request.songs.count) songs from the Kodi host")
            for song in request.songs {
                print(song.title)
            }
        }
        /// Retrieve all songs from an album (Kodi API)
        struct GetSongsTest: KodiAPI {
            /// The optional filter
            var filter: List.Filter?
            /// The optional limits
            var limits: List.Limits?
            /// The sort order
            var sort: List.Sort
            /// The method
            let method = Methods.audioLibraryGetSongs
            /// The JSON creator
            var parameters: Data {
                /// The parameters we ask for
                var params = Params(sort: sort)
                /// The optional filter
                if let filter = filter {
                    params.filter = filter
                }
                /// The optional limit
                if let limits = limits {
                    params.limits = limits
                }
                return buildParams(params: params)
            }
            /// The request struct
            struct Params: Encodable {
                let properties = Audio.Fields.song
                /// The sorting
                let sort: List.Sort
                /// Filter
                var filter: List.Filter?
                /// Limits
                var limits: List.Limits?
            }
            /// The response struct
            struct Response: Decodable {
                /// The list of songs
                let songs: [KodiResponse]
            }
        }
    }
}

extension KodiConnector {
    
    /// Get all songs from the Kodi host
    /// - Returns: All songs from the Kodi host
    func getAllSongs(albums: [MediaItem]) async -> [MediaItem] {
        /// Start with a fresh list
        var songItems = [MediaItem]()
        /// Get songs album by album to avoid a timeout on the JSON request
        for album in albums {
            songItems += await getSongsFromAlbum(album: album)
        }
        return songItems
    }
    
    /// Get all songs from an album
    /// - Parameter album: The Album item
    /// - Returns: All songs from that album
    ///
    /// - Note: Don't ask for all songs from the library in one shot; it will timeout
    func getSongsFromAlbum(album: MediaItem) async -> [MediaItem] {
        let request = AudioLibrary.GetSongs(albumID: album.albumID)
        do {
            let result = try await sendRequest(request: request)
            return setMediaItem(items: result.songs, media: .song)
        } catch {
            /// There are no artists in the library
            logger("Loading songs failed with error: \(error)")
            return [MediaItem]()
        }
    }

    /// Get the details of a song
    /// - Parameter songID: The ID of the song item
    /// - Returns: An updated Media Item
    func getSongDetails(songID: Int) async -> MediaItem {
        let request = AudioLibrary.GetSongDetails(songID: songID)
        do {
            let result = try await sendRequest(request: request)
            /// Make a MediaItem from the KodiResonse and return it
            return setMediaItem(items: [result.songdetails], media: .song).first ?? MediaItem()
        } catch {
            logger("Loading song details failed with error: \(error)")
            return MediaItem()
        }
    }
    
    /// Update the details of a song
    /// - Parameter song: The Media Item
    func setSongDetails(song: MediaItem) async {
        let message = AudioLibrary.SetSongDetails(song: song)
        sendMessage(message: message)
        logger("Details set for '\(song.title)'")
    }
}

// MARK: Song item extension

extension MediaItem {
    
    /// Add additional fields to the song item
    /// - Note: This is a *slow* function...
    mutating func addSongFields() {
        if let album = KodiConnector.shared.media.first(where: { $0.media == .album && $0.albumID == self.albumID }) {
            //print("Album: \(album.title), poster: \(album.poster), song: \(self.title)")
            self.compilation = album.compilation
            self.poster = album.poster
        }
    }
}

// MARK: Kodi API's

extension AudioLibrary {
    
    /// Retrieve all songs from an album (Kodi API)
    struct GetSongs: KodiAPI {
        /// AlbumID argument
        let albumID: Int
        /// The method
        let method = Methods.audioLibraryGetSongs
        /// The JSON creator
        var parameters: Data {
            /// The parameters we ask for
            var params = Params()
            params.filter.albumid = albumID
            return buildParams(params: params)
        }
        /// The request struct
        struct Params: Encodable {
            let properties = Audio.Fields.song
            /// The sorting
            let sort = List.Sort(method: .track, order: .ascending)
            /// Filter
            var filter = Filter()
        }
        /// The filter struct
        struct Filter: Encodable {
            /// The value for the filter
            var albumid: Int = 0
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of songs
            let songs: [KodiResponse]
        }
    }
    
    /// Retrieve details about a specific song (Kodi API)
    struct GetSongDetails: KodiAPI {
        /// Argument: the song we ask for
        var songID: Int
        /// Method
        var method = Methods.audioLibraryGetSongDetails
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
            let properties = Audio.Fields.song
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
    struct SetSongDetails: KodiAPI {
        /// Arguments
        var song: MediaItem
        /// Method
        var method = Methods.audioLibrarySetSongDetails
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
