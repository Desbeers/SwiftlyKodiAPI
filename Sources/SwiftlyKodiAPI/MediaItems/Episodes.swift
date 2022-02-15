//
//  KodiEpisodes.swift
//  VideoPlayer
//
//  Created by Nick Berendsen on 06/02/2022.
//

import Foundation

extension KodiClient {
    
    public func getEpisodes(tvshowID: Int) async -> [EpisodeItem] {
        let request = VideoLibraryGetEpisodes(tvshowID: tvshowID)
        do {
            let result = try await sendRequest(request: request)
            return result.episodes
        } catch {
            /// There are no songs in the library
            print("Loading Episodes failed with error: \(error)")
            return [EpisodeItem]()
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
                "cast"
            ]
            /// The sort order
            /// var sort = KodiClient.SortFields()
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of movies
            let episodes: [EpisodeItem]
        }
    }
    
}

/// The struct for a TV show episode item
public struct EpisodeItem: KodiMediaProtocol, Identifiable, Hashable {
    /// Make it indentifiable
    public var id = UUID()
    /// # Metadata we get from Kodi
    /// The title of the episode
    public var title: String = ""
    /// The subtitle of the episode; it is the name of the TV show; optional
    /// - Note: The `CodingKeys` will take care of the mapping
    public var subtitle: String? = ""
    /// Internal location of the episode
    public var file: String = ""
    /// The description of the episode; Kodi names it 'plot'
    /// - Note: The `CodingKeys` will take care of the mapping
    public var description: String = ""
    public var playCount: Int = 0
    public var season: Int = 0
    
    public var episode: Int = 0
    /// Runtime of the movie
    public var runtime: Int = 0
    /// An array with cast of the episode
    public var cast: [ActorItem] = []
    
    /// Year of release, does not exist for Episodes but required by Protocol
    public var year: Int = 2022
    /// premiered
    public var premiered: String = ""
    
    public var art: [String: String] = [:]
    /// # Coding keys
    /// All the coding keys for a episode item
    public enum CodingKeys: String, CodingKey {
        /// The keys
        case file, season, episode, art, runtime, cast
        /// lowerCamelCase
        case playCount = "playcount"
        /// Use the 'showtitle' as the title
        case title = "showtitle"
        /// Use the 'episode title' as the subtitle
        case subtitle = "title"
        /// Use the 'plot' as description
        case description = "plot"
        /// Use the 'firstaired' as premiered dat
        case premiered = "firstaired"
    }
    /// # Calculated stuff
    /// A Episode has no genre; let's use some other information
    public var genre: [String] {
        return ["Season \(season)", "Episode \(episode)"]
    }
}
