//
//  AudioLibrary+Songs.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

// MARK: getSongs

extension AudioLibrary {

    /// Retrieve all songs (Kodi API)
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

    /// Retrieve all songs after a modification date (Kodi API)
    /// - Parameter modificationDate: The date as a Kodi string
    /// - Returns: The ``Audio/Details/Song`` array after the modified date
    public static func getSongs(modificationDate: String) async -> [Audio.Details.Song] {
        logger("AudioLibrary.getSongs")
        let kodi: KodiConnector = .shared
        let request = GetSongs(
            filter: List.Filter(
                field: .dateModified,
                operate: .greaterThan,
                value: modificationDate
            ),
            limits: nil,
            sort: List.Sort()
        )
        if let result = try? await kodi.sendRequest(request: request) {
            logger("Loaded \(result.songs.count) songs from the Kodi host")
            return result.songs
        }
        /// There are no songs after the modification date
        return [Audio.Details.Song]()
    }

    /// Retrieve all songs (Kodi API)
    fileprivate struct GetSongs: KodiAPI {
        /// The optional filter
        let filter: List.Filter?
        /// The optional limits
        let limits: List.Limits?
        /// The sort order
        let sort: List.Sort
        /// The method
        let method = Method.audioLibraryGetSongs
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(sort: sort, filter: filter, limits: limits))
        }
        /// The parameters struct
        struct Params: Encodable {
            let properties = Audio.Fields.song
            /// The sorting
            let sort: List.Sort
            /// Filter
            let filter: List.Filter?
            /// Limits
            let limits: List.Limits?
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of songs
            let songs: [Audio.Details.Song]
        }
    }
}

// MARK: getSongDetails

extension AudioLibrary {

    /// Retrieve details about a specific song (Kodi API)
    /// - Parameter songID: The ID of the song
    /// - Returns: An ``Audio/Details/Song`` item
    public static func getSongDetails(songID: Library.id) async -> Audio.Details.Song {
        logger("AudioLibrary.getSongDetails")
        let kodi: KodiConnector = .shared
        let request = AudioLibrary.GetSongDetails(songID: songID)
        do {
            let result = try await kodi.sendRequest(request: request)
            return result.songdetails
        } catch {
            logger("Loading song details failed with error: \(error)")
            return Audio.Details.Song()
        }
    }

    /// Retrieve details about a specific song (Kodi API)
    fileprivate struct GetSongDetails: KodiAPI {
        /// The song ID
        let songID: Library.id
        /// The method
        let method = Method.audioLibraryGetSongDetails
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(songID: songID))
        }
        /// The parameters struct
        struct Params: Encodable {
            /// The properties that we ask from Kodi
            let properties = Audio.Fields.song
            /// The ID of the song
            let songID: Library.id
            /// Coding keys
            enum CodingKeys: String, CodingKey {
                case properties
                case songID = "songid"
            }
        }
        /// The response struct
        struct Response: Decodable {
            /// The details of the song
            let songdetails: Audio.Details.Song
        }
    }
}

// MARK: setSongDetails

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
        /// The song
        let song: Audio.Details.Song
        /// The method
        let method = Method.audioLibrarySetSongDetails
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(song: song))
        }
        /// The parameters struct
        struct Params: Encodable {
            /// Init the params
            init(song: Audio.Details.Song) {
                self.songID = song.songID
                self.userRating = song.userRating
                self.playcount = song.playcount
                self.lastPlayed = song.lastPlayed
            }
            /// The song ID
            let songID: Library.id
            /// The rating of the song
            let userRating: Int
            /// The play count of the song
            let playcount: Int
            /// The last played date
            let lastPlayed: String
            /// Coding keys
            enum CodingKeys: String, CodingKey {
                case songID = "songid"
                case userRating = "userrating"
                case playcount
                case lastPlayed = "lastplayed"
            }
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
