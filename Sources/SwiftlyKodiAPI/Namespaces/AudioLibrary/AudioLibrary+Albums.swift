//
//  AudioLibrary+Albums.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

// MARK: getAlbums

extension AudioLibrary {

    /// Retrieve all albums (Kodi API)
    /// - Returns: All albums in an ``Audio/Details/Album`` array
    public static func getAlbums() async -> [Audio.Details.Album] {
        let kodi: KodiConnector = .shared
        if let request = try? await kodi.sendRequest(request: GetAlbums()) {
            logger("Loaded \(request.albums.count) albums from the Kodi host")
            return request.albums
        } else {
            /// There are no albums in the library
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
