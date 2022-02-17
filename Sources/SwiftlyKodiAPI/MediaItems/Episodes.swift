//
//  KodiEpisodes.swift
//  VideoPlayer
//
//  Created by Nick Berendsen on 06/02/2022.
//

import Foundation

extension KodiClient {
    
    func getAllEpisodes(tvshows: [GenericItem]) async -> [GenericItem] {
        var episodes: [GenericItem] = []
        for tvshow in tvshows {
            episodes += await getEpisodes(tvshowID: tvshow.tvshowID)
        }
        return episodes
    }
    
    func getEpisodes(tvshowID: Int) async -> [GenericItem] {
        let request = VideoLibraryGetEpisodes(tvshowID: tvshowID)
        do {
            let result = try await sendRequest(request: request)
            return setMediaKind(media: result.episodes, kind: .episode)
        } catch {
            /// There are no episodes in the library
            print("Loading Episodes failed with error: \(error)")
            return [GenericItem]()
        }
    }
    
    /// Retrieve all episodes of a TV show (Kodi API)
    struct VideoLibraryGetEpisodes: KodiAPI {
        /// TV show ID argument
        let tvshowID: Int
        /// Method
        var method = Method.videoLibraryGetEpisodes
        /// The JSON creator
        var parameters: Data {
            /// The parameters we ask for
            var params = Params()
            params.tvshowid = tvshowID
            /// params.sort.method = KodiClient.SortMethod.title.string()
            /// params.sort.order = KodiClient.SortMethod.ascending.string()
            return buildParams(params: params)
        }
        /// The request struct
        struct Params: Encodable {
            /// The TV show ID
            var tvshowid: Int = -1
            /// The properties that we ask from Kodi
            let properties = [
                "title",
                "plot",
                "playcount",
                "season",
                "episode",
                "art",
                "file",
                "showtitle",
                "firstaired",
                "runtime",
                "cast",
                "tvshowid"
            ]
            /// The sort order
            /// var sort = KodiClient.SortFields()
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of movies
            let episodes: [GenericItem]
        }
    }
}
