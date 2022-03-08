//
//  Episodes.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {

    /// Get all Episodes from the Kodi host
    /// - Parameter tvshows: All the TV shows
    /// - Returns: All the episodes from the Kodi host
    func getAllEpisodes(tvshows: inout [MediaItem]) async -> [MediaItem] {
        var episodes: [MediaItem] = []
        /// Loop over all TV shows
        for (index, tvshow) in tvshows.enumerated() {
            /// Get the Episodes for this TV show
            let episodeList = await getEpisodes(tvshowID: tvshow.tvshowID)
            /// Add them to the list
            episodes += episodeList
            /// Add a seasons list to the TV show item
            /// - Note: specials (season 0) will be the last at the list
            tvshows[index].seasons = episodeList.map { $0.season }
            .removingDuplicates()
            .sorted { ($0 == 0 ? Int.max: $0) < ($1 == 0 ? Int.max : $1) }
        }
        return episodes
    }
    
    /// Get all episodes from a specific TV shpw
    /// - Parameter tvshowID: The ID of the TV show
    /// - Returns: All episodes of the given TV show
    func getEpisodes(tvshowID: Int) async -> [MediaItem] {
        let request = VideoLibraryGetEpisodes(tvshowID: tvshowID)
        do {
            let result = try await sendRequest(request: request)
            return setMediaItem(items: result.episodes, media: .episode)
        } catch {
            /// There are no episodes in the library
            logger("Loading Episodes failed with error: \(error)")
            return [MediaItem]()
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
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of episodes
            let episodes: [KodiResponse]
        }
    }
}
