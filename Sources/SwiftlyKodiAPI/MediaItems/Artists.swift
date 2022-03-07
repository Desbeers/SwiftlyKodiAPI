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
                print("Loading artists failed with error: \(error)")
                return [MediaItem]()
            }
    }
    
    /// Retrieve all artists (Kodi API)
    struct AudioLibraryGetArtists: KodiAPI {
        /// Method
        var method = Method.audioLibraryGetArtists
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
            let properties = [
                "art",
                "description",
                "sortname",
                "isalbumartist",
                "songgenres"
            ]
            /// Sort order
            var sort = KodiConnector.SortFields()
        }
        /// The response struct
        struct Response: Decodable {
            /// The list or artists
            let artists: [KodiItem]
        }
    }
}
