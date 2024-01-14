//
//  AudioLibrary+Songs.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: getSongs

extension AudioLibrary {

    /// Retrieve all songs (Kodi API)
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - filter: An optional filter
    ///   - sort: The sort order
    ///   - limits: The optional limits of the request
    /// - Returns: All requested songs from the library
    public static func getSongs(
        host: HostItem,
        filter: List.Filter? = nil,
        sort: List.Sort = List.Sort(method: .track, order: .ascending),
        limits: List.Limits? = nil
    ) async -> [Audio.Details.Song] {
        let request = GetSongs(host: host, filter: filter, limits: limits, sort: sort)
        do {
            let result = try await JSON.sendRequest(request: request)
            Logger.library.info("Loaded \(result.songs.count) songs from the Kodi host")
            return result.songs
        } catch {
            Logger.library.error("Loading songs failed with error: \(error.localizedDescription)")
            return [Audio.Details.Song]()
        }
    }

    /// Retrieve all songs after a modification date (Kodi API)
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - modificationDate: The date as a Kodi string
    /// - Returns: The ``Audio/Details/Song`` array after the modified date
    public static func getSongs(host: HostItem, modificationDate: String) async -> [Audio.Details.Song] {
        let request = GetSongs(
            host: host,
            filter: List.Filter(
                field: .dateModified,
                operate: .greaterThan,
                value: modificationDate
            ),
            limits: nil,
            sort: List.Sort()
        )
        do {
            let result = try await JSON.sendRequest(request: request)
            Logger.library.info("Loaded \(result.songs.count) songs from the Kodi host")
            return result.songs
        } catch {
            Logger.library.error("Loading songs failed with error: \(error.localizedDescription)")
            return [Audio.Details.Song]()
        }
    }

    /// Retrieve all songs (Kodi API)
    private struct GetSongs: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method = Method.audioLibraryGetSongs
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(sort: sort, filter: filter, limits: limits))
        }
        /// The optional filter
        let filter: List.Filter?
        /// The optional limits
        let limits: List.Limits?
        /// The sort order
        let sort: List.Sort
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
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - songID: The ID of the song
    /// - Returns: An ``Audio/Details/Song`` item
    public static func getSongDetails(host: HostItem, songID: Library.ID) async -> Audio.Details.Song {
        let request = AudioLibrary.GetSongDetails(host: host, songID: songID)
        do {
            let result = try await JSON.sendRequest(request: request)
            Logger.kodiAPI.info("Received details for '\(result.songdetails.title)'")
            return result.songdetails
        } catch {
            Logger.kodiAPI.error("Receiving song details failed with error: \(error)")
            return Audio.Details.Song()
        }
    }

    /// Retrieve details about a specific song (Kodi API)
    private struct GetSongDetails: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method = Method.audioLibraryGetSongDetails
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(songID: songID))
        }
        /// The song ID
        let songID: Library.ID
        /// The parameters struct
        struct Params: Encodable {
            /// The properties that we ask from Kodi
            let properties = Audio.Fields.song
            /// The ID of the song
            let songID: Library.ID
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
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - song: The ``Audio/Details/Song`` item
    public static func setSongDetails(host: HostItem, song: Audio.Details.Song) async {
        let message = AudioLibrary.SetSongDetails(host: host, song: song)
        JSON.sendMessage(message: message)
        Logger.library.info("Details set for '\(song.title)'")
    }

    /// Update the given song with the given details (Kodi API)
    private struct SetSongDetails: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method = Method.audioLibrarySetSongDetails
        /// The song
        let song: Audio.Details.Song
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
            let songID: Library.ID
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
