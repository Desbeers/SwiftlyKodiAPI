//
//  KodiTVshows.swift
//  VideoPlayer
//
//  Created by Nick Berendsen on 04/02/2022.
//

import Foundation

extension KodiClient {
    
    func getTVshows() async -> [KodiItem] {
        let request = VideoLibraryGetTVShows()
        do {
            let result = try await sendRequest(request: request)
            return setMediaKind(items: result.tvshows, media: .tvshow)
        } catch {
            /// There are no songs in the library
            print("Loading TV shows failed with error: \(error)")
            return [KodiItem]()
        }
    }
    
    /// Retrieve all TV shows (Kodi API)
    struct VideoLibraryGetTVShows: KodiAPI {
        /// Method
        var method = Method.videoLibraryGetTVShows
        /// The JSON creator
        var parameters: Data {
            /// The parameters we ask for
            var params = Params()
            params.sort = sort(method: .title, order: .ascending)
            return buildParams(params: params)
        }
        /// The request struct
        struct Params: Encodable {
            /// The properties that we ask from Kodi
            let properties = [
                "title",
                "sorttitle",
                "file",
                "plot",
                "genre",
                "art",
                "year",
                "premiered",
                "playcount"
            ]
            /// The sort order
            var sort = KodiClient.SortFields()
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of TV shows
            let tvshows: [KodiItem]
        }
    }
}
