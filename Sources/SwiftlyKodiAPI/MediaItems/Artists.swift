//
//  Artists.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK: getArtists

extension AudioLibrary {

    /// Get all artists from the Kodi host
    /// - Returns: All artists from the Kodi host
    public static func getArtists() async -> [Audio.Details.Artist] {
        let kodi: KodiConnector = .shared
        if let request = try? await kodi.sendRequest(request: GetArtists()) {
            logger("Loaded \(request.artists.count) artists from the Kodi host")
            return request.artists
        }
        return [Audio.Details.Artist]()
    }
    
    /// Retrieve all artists (Kodi API)
    struct GetArtists: KodiAPI {
        /// The method
        var method = Methods.audioLibraryGetArtists
        /// The parameters
        var parameters: Data {
            buildParams(params: Params())
        }
        /// The request struct
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

// MARK: getArtists

//extension AudioLibrary {
//
//    /// Get all artists from the Kodi host
//    /// - Returns: All artists from the Kodi host
//    public static func getArtists() async -> [MediaItem] {
//        let kodi: KodiConnector = .shared
//        if let request = try? await kodi.sendRequest(request: GetArtists()) {
//            logger("Loaded \(request.artists.count) artists from the Kodi host")
//            return kodi.setMediaItem(items: request.artists, media: .artist)
//        } else {
//            /// There are no artists in the library
//            return [MediaItem]()
//        }
//    }
//
//    /// Retrieve all artists (Kodi API)
//    struct GetArtists: KodiAPI {
//
//        /// The method
//        var method = Methods.audioLibraryGetArtists
//        /// The parameters
//        var parameters: Data {
//            buildParams(params: Params())
//        }
//        /// The request struct
//        struct Params: Encodable {
//            /// Get all artists
//            let albumartistsonly = false
//            /// The artist properties
//            let properties = Audio.Fields.artist
//            /// Sort order
//            let sort = List.Sort(method: .artist, order: .ascending)
//        }
//        /// The response struct
//        struct Response: Decodable {
//            /// The list of artists
//            let artists: [KodiResponse]
//        }
//    }
//}
