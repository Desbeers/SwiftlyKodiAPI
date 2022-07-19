//
//  AudioLibrary+Songs.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK:  getSongs

extension AudioLibrary {
    
    /// Retrieve all songs  (Kodi API)
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
    ) async -> [Audio.Details.Song] {
        logger("AudioLibrary.getSongs")
        let kodi: KodiConnector = .shared
        if let result = try? await kodi.sendRequest(request: GetSongs(filter: filter, limits: limits, sort: sort)) {
            logger("Loaded \(result.songs.count) songs from the Kodi host")
            return result.songs
        }
        /// There are no songs in the library
        return [Audio.Details.Song]()
    }
    
    /// Retrieve all songs  (Kodi API)
    fileprivate struct GetSongs: KodiAPI {
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
            let songs: [Audio.Details.Song]
        }
    }
}

// MARK:  getSongDetails

extension AudioLibrary {
    
    /// Retrieve details about a specific song (Kodi API)
    /// - Parameter songID: The ID of the song
    /// - Returns: An ``Audio/Details/Song`` item
    public static func getSongDetails(songID: Int) async -> Audio.Details.Song {
        logger("AudioLibrary.getSongDetails")
        let kodi: KodiConnector = .shared
        let request = AudioLibrary.GetSongDetails(songID: songID)
        do {
            let result = try await kodi.sendRequest(request: request)
            
            return result.songdetails
            /// Make a MediaItem from the KodiResonse and return it
            //return kodi.setMediaItem(items: [result.songdetails], media: .song).first ?? MediaItem()
        } catch {
            logger("Loading song details failed with error: \(error)")
            return Audio.Details.Song()
        }
    }
    
    /// Retrieve details about a specific song (Kodi API)
    fileprivate struct GetSongDetails: KodiAPI {
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
            var songdetails: Audio.Details.Song
        }
    }
}

// MARK:  setSongDetails

extension AudioLibrary {

    /// Update the given song with the given details (Kodi API)
    /// - Parameter song: The ``Audio/Details/Song`` item
    public static func setSongDetails(song: Audio.Details.Song) async {
        logger("AudioLibrary.setSongDetails")
        let kodi: KodiConnector = .shared
        let message = AudioLibrary.SetSongDetails(song: song)
        kodi.sendMessage(message: message)
        logger("Details set for '\(song.title)'")
    }
    
    /// Update the given song with the given details (Kodi API)
    fileprivate struct SetSongDetails: KodiAPI {
        /// Arguments
        var song: Audio.Details.Song
        /// Method
        var method = Methods.audioLibrarySetSongDetails
        /// The JSON creator
        var parameters: Data {
            buildParams(params: Params(song: song))
        }
        /// The request struct
        struct Params: Encodable {
            internal init(song: Audio.Details.Song) {
                self.songid = song.songID
                self.userrating = song.userRating
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
