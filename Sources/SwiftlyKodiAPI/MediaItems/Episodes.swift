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
    
    /// Get the details of an episode
    /// - Parameter episodeID: The ID of the episode item
    /// - Returns: An updated Media Item
    func getEpisodeDetails(episodeID: Int) async -> MediaItem {
        let request = VideoLibraryGetEpisodeDetails(episodeID: episodeID)
        do {
            let result = try await sendRequest(request: request)
            /// Make a MediaItem from the KodiResonse and return it
            return setMediaItem(items: [result.episodedetails], media: .episode).first ?? MediaItem()
        } catch {
            logger("Loading episode details failed with error: \(error)")
            return MediaItem()
        }
    }
    
    /// Update the details of a song
    /// - Parameter song: The Media Item
    func setEpisodeDetails(episode: MediaItem) async {
        let message = VideoLibrarySetEpisodeDetails(episode: episode)
        sendMessage(message: message)
        logger("Details set for '\(episode.title)'")
    }
}

// MARK: Kodi API's

extension KodiConnector {
    
    /// The Song properties we ask from Kodi
    static var videoFieldsEpisode = [
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
        "tvshowid",
        "lastplayed"
    ]

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
            let properties = videoFieldsEpisode
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of episodes
            let episodes: [KodiResponse]
        }
    }
    
    /// Retrieve details about a specific episode (Kodi API)
    struct VideoLibraryGetEpisodeDetails: KodiAPI {
        /// Argument: the episode we ask for
        var episodeID: Int
        /// Method
        var method = Method.videoLibraryGetEpisodeDetails
        /// The JSON creator
        var parameters: Data {
            /// The parameters we ask for
            var params = Params()
            params.episodeid = episodeID
            return buildParams(params: params)
        }
        /// The request struct
        struct Params: Encodable {
            /// The properties that we ask from Kodi
            let properties = KodiConnector.videoFieldsEpisode
            /// The ID of the episode
            var episodeid: Int = 0
        }
        /// The response struct
        struct Response: Decodable {
            /// The details of the song
            var episodedetails: KodiResponse
        }
    }
    
    /// Update the given episode with the given details (Kodi API)
    struct VideoLibrarySetEpisodeDetails: KodiAPI {
        /// Arguments
        var episode: MediaItem
        /// Method
        var method = Method.videoLibrarySetEpisodeDetails
        /// The JSON creator
        var parameters: Data {
            /// The parameters
            let params = Params(episode: episode)
            return buildParams(params: params)
        }
        /// The request struct
        /// - Note: The properties we want to set
        struct Params: Encodable {
            internal init(episode: MediaItem) {
                self.episodeid = episode.episodeID
                self.userrating = episode.rating
                self.playcount = episode.playcount
                self.lastplayed = episode.lastPlayed
            }
            /// The song ID
            var episodeid: Int
            /// The rating of the song
            var userrating: Int
            /// The play count of the song
            var playcount: Int
            /// The last played date
            var lastplayed: String
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
