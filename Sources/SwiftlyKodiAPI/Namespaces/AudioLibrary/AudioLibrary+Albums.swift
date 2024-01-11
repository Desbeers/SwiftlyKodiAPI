//
//  AudioLibrary+Albums.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: getAlbums

extension AudioLibrary {

    /// Retrieve all albums (Kodi API)
    /// - Returns: All albums in an ``Audio/Details/Album`` array
    public static func getAlbums() async -> [Audio.Details.Album] {
        let kodi: KodiConnector = .shared
        do {
            let result = try await kodi.sendRequest(request: GetAlbums())
            Logger.library.info("Loaded \(result.albums.count) albums from the Kodi host")
            return result.albums
        } catch {
            Logger.library.error("Loading albums failed with error: \(error.localizedDescription)")
            return [Audio.Details.Album]()
        }
    }

    /// Retrieve all albums (Kodi API)
    fileprivate struct GetAlbums: KodiAPI {
        /// The method
        let method = Method.audioLibraryGetAlbums
        /// The parameters
        var parameters: Data {
            buildParams(params: Params())
        }
        /// The parameters struct
        struct Params: Encodable {
            /// The album properties
            let properties = Audio.Fields.album
            /// Sort order
            let sort = List.Sort(method: .artist, order: .ascending)
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of albums
            let albums: [Audio.Details.Album]
        }
    }
}
