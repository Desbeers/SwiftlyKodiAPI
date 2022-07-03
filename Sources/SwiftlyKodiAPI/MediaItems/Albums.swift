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
    public static func getAlbums2() async -> [Audio.Details.Album] {
        let kodi: KodiConnector = .shared
        if let request = try? await kodi.sendRequest(request: GetAlbums2()) {
            logger("Loaded \(request.albums.count) albums from the Kodi host")
            return request.albums
            //return kodi.setMediaItem(items: request.albums, media: .album)
        } else {
            /// There are no albums in the library
            return [Audio.Details.Album]()
        }
    }
    
    /// Retrieve all albums (Kodi API)
    struct GetAlbums2: KodiAPI {
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

// MARK: getAlbums

extension AudioLibrary {

    /// Get all albums from the Kodi host
    /// - Returns: All albums from the Kodi host
    public static func getAlbums() async -> [MediaItem] {
        let kodi: KodiConnector = .shared
        if let request = try? await kodi.sendRequest(request: GetAlbums()) {
            logger("Loaded \(request.albums.count) albums from the Kodi host")
            return kodi.setMediaItem(items: request.albums, media: .album)
        } else {
            /// There are no albums in the library
            return [MediaItem]()
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
            let albums: [KodiResponse]
        }
    }
}

// MARK: Album item extension

extension MediaItem {
    
    /// Add additional fields to the album item
    /// - Note: This is a *slow* function...
    mutating func addAlbumFields() {
        if self.fanart == self.poster {
            if let artist = KodiConnector.shared.media.first(where: { $0.media == .artist && $0.artistID == self.artistIDs.first }) {
                self.fanart = artist.fanart
            }
        }
    }
}
