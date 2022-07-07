//
//  Albums.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK: getAlbums

extension AudioLibrary {

    /// Get all albums from the Kodi host
    /// - Returns: All albums from the Kodi host
    public static func getAlbums() async -> [Audio.Details.Album] {
        let kodi: KodiConnector = .shared
        if let request = try? await kodi.sendRequest(request: GetAlbums()) {
            logger("Loaded \(request.albums.count) albums from the Kodi host")
            return request.albums
            //return kodi.setMediaItem(items: request.albums, media: .album)
        } else {
            /// There are no albums in the library
            return [Audio.Details.Album]()
        }
    }
    
    /// Retrieve all albums (Kodi API)
    struct GetAlbums: KodiAPI {
        /// The method
        let method = Methods.audioLibraryGetAlbums
        /// The parameters
        var parameters: Data {
            buildParams(params: Params())
        }
        /// The request struct
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
