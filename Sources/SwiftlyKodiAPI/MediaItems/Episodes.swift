//
//  Episodes.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK:  getEpisodes

extension VideoLibrary {

    /// Get all the episodes from the Kodi host
    /// - Parameter tvshowID: The optional TV show ID
    /// - Returns: The requested episodes
    public static func getEpisodes(tvshowID: Int? = nil) async -> [MediaItem] {
        let kodi: KodiConnector = .shared
        if let result = try? await kodi.sendRequest(request: GetEpisodes(tvshowID: tvshowID)) {
            logger("Loaded \(result.episodes.count) episodes from the Kodi host")
            return kodi.setMediaItem(items: result.episodes, media: .episode)
        }
        /// There are no episodes in the library
        return [MediaItem]()
    }
    
    /// Retrieve all episodes of a TV show (Kodi API)
    struct GetEpisodes: KodiAPI {
        /// TV show ID argument
        var tvshowID: Int?
        /// Method
        let method = Methods.videoLibraryGetEpisodes
        /// The JSON creator
        var parameters: Data {
            /// The parameters we ask for
            var params = Params()
            if let tvshowID = tvshowID {
                params.tvshowid = tvshowID
            }
            //params.tvshowid = tvshowID
            return buildParams(params: params)
        }
        /// The request struct
        struct Params: Encodable {
            /// The TV show ID
            var tvshowid: Int?
            /// The properties that we ask from Kodi
            let properties = Video.Fields.episode
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of episodes
            let episodes: [KodiResponse]
        }
    }
}

// MARK:  getEpisodeDetails

extension VideoLibrary {
    
    /// Get the details of an episode
    /// - Parameter episodeID: The ID of the episode item
    /// - Returns: An updated Media Item
    public static func getEpisodeDetails(episodeID: Int) async -> MediaItem {
        let kodi: KodiConnector = .shared
        let request = GetEpisodeDetails(episodeID: episodeID)
        do {
            let result = try await kodi.sendRequest(request: request)
            /// Make a MediaItem from the KodiResonse and return it
            return kodi.setMediaItem(items: [result.episodedetails], media: .episode).first ?? MediaItem()
        } catch {
            logger("Loading episode details failed with error: \(error)")
            return MediaItem()
        }
    }
    
    /// Retrieve details about a specific episode (Kodi API)
    struct GetEpisodeDetails: KodiAPI {
        /// Argument: the episode we ask for
        var episodeID: Int
        /// Method
        var method = Methods.videoLibraryGetEpisodeDetails
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
            let properties = Video.Fields.episode
            /// The ID of the episode
            var episodeid: Int = 0
        }
        /// The response struct
        struct Response: Decodable {
            /// The details of the song
            var episodedetails: KodiResponse
        }
    }
}

// MARK:  setEpisodeDetails

extension VideoLibrary {
    
    /// Set the details of an episode item
    /// - Parameter episode: The episode as Media Item
    public static func setEpisodeDetails(episode: MediaItem) async {
        let kodi: KodiConnector = .shared
        let message = SetEpisodeDetails(episode: episode)
        kodi.sendMessage(message: message)
        logger("Details set for '\(episode.title)'")
    }
    
    /// Update the given episode with the given details (Kodi API)
    struct SetEpisodeDetails: KodiAPI {
        /// Arguments
        var episode: MediaItem
        /// Method
        var method = Methods.videoLibrarySetEpisodeDetails
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
