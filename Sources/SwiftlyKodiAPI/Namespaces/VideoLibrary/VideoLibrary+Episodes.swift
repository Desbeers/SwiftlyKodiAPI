//
//  VideoLibrary+Episodes.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

// MARK: getEpisodes

extension VideoLibrary {

    /// Retrieve all episodes of a TV show (Kodi API)
    /// - Parameter tvshowID: The optional TV show ID
    /// - Returns: All TV shows in an ``Video/Details/Episode`` array
    public static func getEpisodes(tvshowID: Library.id? = nil) async -> [Video.Details.Episode] {
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
        /// The TV show ID
        var tvshowID: Library.id?
        /// The method
        let method = Method.videoLibraryGetEpisodes
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(tvshowID: tvshowID))
        }
        /// The parameters struct
        struct Params: Encodable {
            /// The TV show ID
            let tvshowID: Library.id?
            /// The properties that we ask from Kodi
            let properties = Video.Fields.episode
            /// The sorting
            let sort = List.Sort(method: .tvshowTitle, order: .ascending)
            /// Coding keys
            enum CodingKeys: String, CodingKey {
                case tvshowID = "tvshowid"
                case properties
                case sort
            }
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of episodes
            let episodes: [Video.Details.Episode]
        }
    }
}

// MARK: getEpisodeDetails

extension VideoLibrary {

    /// Retrieve details about a specific episode (Kodi API)
    /// - Parameter episodeID: The ID of the episode
    /// - Returns: A ``Video/Details/Episode`` item
    public static func getEpisodeDetails(episodeID: Library.id) async -> Video.Details.Episode {
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
        /// The episode ID
        var episodeID: Library.id
        /// The method
        var method = Method.videoLibraryGetEpisodeDetails
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(episodeID: episodeID))
        }
        /// The parameters struct
        struct Params: Encodable {
            /// The properties that we ask from Kodi
            let properties = Video.Fields.episode
            /// The ID of the episode
            let episodeID: Library.id
            /// Coding keys
            enum CodingKeys: String, CodingKey {
                case properties
                case episodeID = "episodeid"
            }
        }
        /// The response struct
        struct Response: Decodable {
            /// The details of the episode
            var episodedetails: Video.Details.Episode
        }
    }
}

// MARK: setEpisodeDetails

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
        /// The episode
        var episode: Video.Details.Episode
        /// The method
        let method = Method.videoLibrarySetEpisodeDetails
        /// The parameters
        var parameters: Data {
            /// The parameters
            let params = Params(episode: episode)
            return buildParams(params: params)
        }
        /// The parameters struct
        struct Params: Encodable {
            /// Init the params
            init(episode: Video.Details.Episode) {
                self.episodeID = episode.episodeID
                self.userRating = episode.userRating
                self.playcount = episode.playcount
                self.lastPlayed = episode.lastPlayed
                self.resume = episode.resume
            }
            /// The episode ID
            let episodeID: Library.id
            /// The rating of the song
            let userRating: Int
            /// The play count of the song
            let playcount: Int
            /// The last played date
            let lastPlayed: String
            /// The resume time
            let resume: Video.Resume
            /// Coding keys
            enum CodingKeys: String, CodingKey {
                case episodeID = "episodeid"
                case userRating = "userrating"
                case playcount
                case lastPlayed = "lastplayed"
                case resume
            }
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
