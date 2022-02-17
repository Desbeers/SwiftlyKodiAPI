//
//  KodiMovies.swift
//  VideoPlayer
//
//  Created by Nick Berendsen on 01/02/2022.
//

import Foundation

extension KodiClient {
    
    func getMusicVideos() async -> [GenericItem] {
        let request = VideoLibraryGetMusicVideos()
        do {
            let result = try await sendRequest(request: request)
            return setMediaKind(media: result.musicvideos, kind: .musicvideo)
        } catch {
            /// There are no music videos in the library
            print("Loading music videos failed with error: \(error)")
            return [GenericItem]()
        }
    }
    
    /// Retrieve all music videos (Kodi API)
    struct VideoLibraryGetMusicVideos: KodiAPI {
        /// Method
        var method = Method.videoLibraryGetMusicVideos
        /// The JSON creator
        var parameters: Data {
            /// The parameters we ask for
            var params = Params()
            params.sort = sort(method: .artist, order: .ascending)
            return buildParams(params: params)
        }
        /// The request struct
        struct Params: Encodable {
            /// The properties that we ask from Kodi
            let properties = [
                "title",
                "artist",
                "album",
                "genre",
                "file",
                "year",
                "premiered",
                "art",
                "playcount",
                "plot",
                "runtime"
            ]
            /// The sort order
            var sort = KodiClient.SortFields()
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of music videos
            let musicvideos: [GenericItem]
        }
    }
}
