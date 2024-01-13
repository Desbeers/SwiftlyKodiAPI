//
//  AudioLibrary+Artists.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: getArtists

extension AudioLibrary {

    /// Retrieve all artists (Kodi API)
    /// - Parameter host: The ``HostItem`` for the request
    /// - Returns: All artists in an ``Audio/Details/Artist`` array
    public static func getArtists(host: HostItem) async -> [Audio.Details.Artist] {
        do {
            let result = try await JSON.sendRequest(request: GetArtists(host: host))
            Logger.library.info("Loaded \(result.artists.count) artists from the Kodi host")
            return result.artists
        } catch {
            Logger.library.error("Loading artists failed with error: \(error.localizedDescription)")
            return [Audio.Details.Artist]()
        }
    }

    /// Retrieve all artists (Kodi API)
    fileprivate struct GetArtists: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        var method = Method.audioLibraryGetArtists
        /// The parameters
        var parameters: Data {
            buildParams(params: Params())
        }
        /// The parameters struct
        struct Params: Encodable {
            /// Get all artists
            let albumartistsonly = false
            /// The artist properties
            let properties = Audio.Fields.artist
            /// Sort order
            let sort = List.Sort(method: .artist, order: .ascending)
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of artists
            let artists: [Audio.Details.Artist]
        }
    }
}

// MARK: getArtistDetails

extension AudioLibrary {

    /// Retrieve details about a specific artist (Kodi API)
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - artistID: The ID of the artist
    /// - Returns: An ``Audio/Details/Artist`` item
    public static func getArtistDetails(host: HostItem, artistID: Library.ID) async -> Audio.Details.Artist {
        let request = AudioLibrary.GetArtistDetails(host: host, artistID: artistID)
        do {
            let result = try await JSON.sendRequest(request: request)
            return result.artistdetails
        } catch {
            Logger.kodiAPI.error("Loading artist details failed with error: \(error)")
            return Audio.Details.Artist(media: .none)
        }
    }

    /// Retrieve details about a specific artist (Kodi API)
    fileprivate struct GetArtistDetails: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method = Method.audioLibraryGetArtistDetails
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(artistID: artistID))
        }
        /// The artist ID
        let artistID: Library.ID
        /// The parameters struct
        struct Params: Encodable {
            /// The properties that we ask from Kodi
            let properties = Audio.Fields.artist
            /// The ID of the artist
            let artistID: Library.ID
            /// Coding keys
            enum CodingKeys: String, CodingKey {
                case properties
                case artistID = "artistid"
            }
        }
        /// The response struct
        struct Response: Decodable {
            /// The details of the song
            let artistdetails: Audio.Details.Artist
        }
    }
}
