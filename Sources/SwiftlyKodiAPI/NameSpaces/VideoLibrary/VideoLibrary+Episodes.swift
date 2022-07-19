//
//  VideoLibrary+Episodes.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK:  getEpisodes

extension VideoLibrary {

    /// Retrieve all episodes of a TV show (Kodi API)
    /// - Parameter tvshowID: The optional TV show ID
    /// - Returns: All TV shows in an ``Video/Details/Episode`` array
    public static func getEpisodes(tvshowID: Int? = nil) async -> [Video.Details.Episode] {
        let kodi: KodiConnector = .shared
        if let result = try? await kodi.sendRequest(request: GetEpisodes(tvshowID: tvshowID)) {
            logger("Loaded \(result.episodes.count) episodes from the Kodi host")
            return result.episodes
        }
        /// There are no episodes in the library
        return [Video.Details.Episode]()
    }
    
    /// Retrieve all episodes of a TV show (Kodi API)
    fileprivate struct GetEpisodes: KodiAPI {
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
            /// The sorting
            let sort = List.Sort(method: .tvshowTitle, order: .ascending)
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of episodes
            let episodes: [Video.Details.Episode]
        }
    }
}

// MARK:  getEpisodeDetails

extension VideoLibrary {
    
    /// Retrieve details about a specific episode (Kodi API)
    /// - Parameter episodeID: The ID of the episode
    /// - Returns: A ``Video/Details/Episode`` item
    public static func getEpisodeDetails(episodeID: Int) async -> Video.Details.Episode {
        let kodi: KodiConnector = .shared
        let request = GetEpisodeDetails(episodeID: episodeID)
        do {
            let result = try await kodi.sendRequest(request: request)
            return result.episodedetails
        } catch {
            logger("Loading episode details failed with error: \(error)")
            return Video.Details.Episode()
        }
    }
    
    /// Retrieve details about a specific episode (Kodi API)
    fileprivate struct GetEpisodeDetails: KodiAPI {
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
            /// The details of the episode
            var episodedetails: Video.Details.Episode
        }
    }
}

// MARK:  setEpisodeDetails

extension VideoLibrary {
    
    /// Update the given episode with the given details (Kodi API)
    /// - Parameter episode: The ``Video/Details/Episode`` item
    public static func setEpisodeDetails(episode: Video.Details.Episode) async {
        let kodi: KodiConnector = .shared
        let message = SetEpisodeDetails(episode: episode)
        kodi.sendMessage(message: message)
        logger("Details set for '\(episode.title)'")
    }
    
    /// Update the given episode with the given details (Kodi API)
    fileprivate struct SetEpisodeDetails: KodiAPI {
        /// Arguments
        var episode: Video.Details.Episode
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
            internal init(episode: Video.Details.Episode) {
                self.episodeid = episode.episodeID
                self.userrating = episode.userRating
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
