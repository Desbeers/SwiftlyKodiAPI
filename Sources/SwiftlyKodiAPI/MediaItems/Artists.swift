//
//  Artists.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {

    /// Get all artists from the Kodi host
    /// - Returns: All artists from the Kodi host
    func getArtists() async -> [MediaItem] {
            let request = AudioLibraryGetArtists()
            do {
                let result = try await sendRequest(request: request)
                return setMediaItem(items: result.artists, media: .artist)
            } catch {
                /// There are no artists in the library
                logger("Loading artists failed with error: \(error)")
                return [MediaItem]()
            }
    }
    
    /// Retrieve all artists (Kodi API)
    struct AudioLibraryGetArtists: KodiAPI {
        /// Method
        var method = Methods.audioLibraryGetArtists
        /// The JSON creator
        var parameters: Data {
            var params = Params()
            params.sort = sort(method: .artist, order: .ascending)
            return buildParams(params: params)
        }
        /// The request struct
        struct Params: Encodable {
            /// Get all artists
            let albumartistsonly = false
            /// The properties that we ask from Kodi
            let properties = Audio.Fields.artist
            /// Sort order
            var sort = KodiConnector.SortFields()
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of artists
            let artists: [KodiResponse]
        }
    }
}

// MARK: Kodi API's

extension AudioLibrary {
    
    /// Retrieve all artists
    struct GetArtists: KodiAPI {
        /// Method
        var method = Methods.audioLibraryGetArtists
        /// The JSON creator
        var parameters: Data {
            var params = Params()
            params.sort = sort(method: .artist, order: .ascending)
            return buildParams(params: params)
        }
        /// The request struct
        struct Params: Encodable {
            /// Get all artists
            let albumartistsonly = false
            /// The properties that we ask from Kodi
            let properties = Audio.Fields.artist
            /// Sort order
            var sort = KodiConnector.SortFields()
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of artists
            let artists: [KodiResponse]
        }
    }
    
}

