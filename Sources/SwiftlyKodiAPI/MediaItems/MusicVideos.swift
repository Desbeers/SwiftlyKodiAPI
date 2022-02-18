//
//  MusicVideos.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {
    
    /// Get all the music videos from the Kodi host
    /// - Returns: All music videos from the Kodi host
    func getMusicVideos() async -> [KodiItem] {
        let request = VideoLibraryGetMusicVideos()
        do {
            let result = try await sendRequest(request: request)
            return setMediaKind(items: result.musicvideos, media: .musicvideo)
        } catch {
            /// There are no music videos in the library
            print("Loading music videos failed with error: \(error)")
            return [KodiItem]()
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
                "runtime",
                "dateadded"
            ]
            /// The sort order
            var sort = KodiConnector.SortFields()
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of music videos
            let musicvideos: [KodiItem]
        }
    }
}
