//
//  AudioLibrary+Artists.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

// MARK: getArtists

extension AudioLibrary {

    /// Retrieve all artists (Kodi API)
    /// - Returns: All artists in an ``Audio/Details/Artist`` array
    public static func getArtists() async -> [Audio.Details.Artist] {
        let kodi: KodiConnector = .shared
        if let request = try? await kodi.sendRequest(request: GetArtists()) {
            logger("Loaded \(request.artists.count) artists from the Kodi host")
            return request.artists
        }
        return [Audio.Details.Artist]()
    }

    /// Retrieve all artists (Kodi API)
    fileprivate struct GetArtists: KodiAPI {
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
    /// - Parameter artistID: The ID of the artist
    /// - Returns: An ``Audio/Details/Artist`` item
    public static func getArtistDetails(artistID: Library.id) async -> Audio.Details.Artist {
        logger("AudioLibrary.getArtistDetails")
        let kodi: KodiConnector = .shared
        let request = AudioLibrary.GetArtistDetails(artistID: artistID)
        do {
            let result = try await kodi.sendRequest(request: request)
            return result.artistdetails
        } catch {
            logger("Loading artist details failed with error: \(error)")
            return Audio.Details.Artist(media: .none)
        }
    }

    /// Retrieve details about a specific artist (Kodi API)
    fileprivate struct GetArtistDetails: KodiAPI {
        /// The artist ID
        let artistID: Library.id
        /// The method
        let method = Method.audioLibraryGetArtistDetails
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(artistID: artistID))
        }
        /// The parameters struct
        struct Params: Encodable {
            /// The properties that we ask from Kodi
            let properties = Audio.Fields.artist
            /// The ID of the artist
            let artistID: Library.id
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
