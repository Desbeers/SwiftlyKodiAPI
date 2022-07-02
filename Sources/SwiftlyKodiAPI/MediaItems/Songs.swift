//
//  Songs.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK:  getSongs

extension AudioLibrary {
    
    /// Get songs from the library
    ///
    /// ## Limitations
    ///
    ///  Loading songs from the host can be expensive!
    ///
    /// ## Examples
    ///
    /// *The 10 last played songs:*
    ///
    ///  ```swift
    ///     let lastPlayed = await AudioLibrary.getSongs(
    ///         sort: List.Sort(method: .lastPlayed, order: .descending),
    ///         limits: List.Limits(end: 10)
    ///     )
    /// ```
    ///
    /// *The tracks from a specific album:*
    ///
    ///  ```swift
    ///     let albumTracks = await AudioLibrary.getSongs(
    ///         filter: List.Filter(albumID: 3),
    ///         sort: List.Sort(method: .track, order: .ascending)
    ///     )
    /// ```
    ///
    /// - Parameters:
    ///   - filter: An optional filter
    ///   - sort: The sort order
    ///   - limits: The optional limits of the request
    /// - Returns: All requested songs from the library
    public static func getSongs(
        filter: List.Filter? = nil,
        sort: List.Sort = List.Sort(method: .track, order: .ascending),
        limits: List.Limits? = nil
    ) async -> [MediaItem] {
        let kodi: KodiConnector = .shared
        if let result = try? await kodi.sendRequest(request: GetSongs(filter: filter, limits: limits, sort: sort)) {
            logger("Loaded \(result.songs.count) songs from the Kodi host")
            return kodi.setMediaItem(items: result.songs, media: .song)
        }
        /// There are no songs in the library
        return [MediaItem]()
    }
    
    /// Retrieve all songs from an album (Kodi API)
    struct GetSongs: KodiAPI {
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

// MARK:  getSongDetails

extension AudioLibrary {
    
    /// Get the details of a song
    /// - Parameter songID: The ID of the song item
    /// - Returns: An updated Media Item
    public static func getSongDetails(songID: Int) async -> MediaItem {
        let kodi: KodiConnector = .shared
        let request = AudioLibrary.GetSongDetails(songID: songID)
        do {
            let result = try await kodi.sendRequest(request: request)
            /// Make a MediaItem from the KodiResonse and return it
            return kodi.setMediaItem(items: [result.songdetails], media: .song).first ?? MediaItem()
        } catch {
            logger("Loading song details failed with error: \(error)")
            return MediaItem()
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
}

// MARK:  setSongDetails

extension AudioLibrary {

    /// Update the details of a song
    /// - Parameter song: The Media Item
    public static func setSongDetails(song: MediaItem) async {
        let kodi: KodiConnector = .shared
        let message = AudioLibrary.SetSongDetails(song: song)
        kodi.sendMessage(message: message)
        logger("Details set for '\(song.title)'")
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

extension KodiConnector {
    
    /// Get all songs from the Kodi host
    /// - Returns: All songs from the Kodi host
    func getAllSongs(albums: [MediaItem]) async -> [MediaItem] {
        /// Start with a fresh list
        var songItems = [MediaItem]()
        /// Get songs album by album to avoid a timeout on the JSON request
        for album in albums {
            songItems += await AudioLibrary.getSongs(filter: List.Filter(albumID: album.albumID))
        }
        return songItems
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
