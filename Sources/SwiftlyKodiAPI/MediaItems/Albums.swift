//
//  File.swift
//  
//
//  Created by Nick Berendsen on 08/03/2022.
//

import Foundation

extension KodiConnector {

    /// Get all albums from the Kodi host
    /// - Returns: All albums from the Kodi host
    func getAlbums() async -> [MediaItem] {
            let request = AudioLibraryGetAlbums()
            do {
                let result = try await sendRequest(request: request)
                return setMediaItem(items: result.albums, media: .album)
            } catch {
                /// There are no artists in the library
                logger("Loading albums failed with error: \(error)")
                return [MediaItem]()
            }
    }
    
    /// Retrieve all albums (Kodi API)
    struct AudioLibraryGetAlbums: KodiAPI {
        /// Method
        let method = Method.audioLibraryGetAlbums
        /// The JSON creator
        var parameters: Data {
            var params = Params()
            params.sort = sort(method: .artist, order: .ascending)
            return buildParams(params: params)
        }
        /// The request struct
        struct Params: Encodable {
            /// The properties
            let properties = [
                "artistid",
                "artist",
                "sortartist",
                "description",
                "title",
                "year",
                "playcount",
                "totaldiscs",
                "genre",
                "art",
                "compilation",
                "dateadded",
                "lastplayed",
                "albumduration"
            ]
            /// Sort order
            var sort = KodiConnector.SortFields()
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of albums
            let albums: [KodiResponse]
        }
    }
}
