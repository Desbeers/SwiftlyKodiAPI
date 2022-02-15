//
//  KodiTVshows.swift
//  VideoPlayer
//
//  Created by Nick Berendsen on 04/02/2022.
//

import Foundation

extension KodiClient {
    
    public func getTVshows() async -> [TVshowItem] {
        let request = VideoLibraryGetTVShows()
        do {
            let result = try await sendRequest(request: request)
            return result.tvshows
        } catch {
            /// There are no songs in the library
            print("Loading TV shows failed with error: \(error)")
            return [TVshowItem]()
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
            /// The list of movies
            let tvshows: [TVshowItem]
        }
    }
}

/// The struct for a TV show item
public struct TVshowItem: KodiMediaProtocol, Identifiable, Hashable {
    /// Make it indentifiable
    public var id = UUID()
    /// # Metadata we get from Kodi
    /// The ID of the TV show
    public var tvshowID: Int = 0
    /// Title of the TV show
    public var title: String = ""
    /// The description of the TV show  (is actually the plot)
    public var description: String = ""
    /// Location of the TV show
    public var file: String = ""
    /// An array with the movie genres
    public var genre: [String] = [""]
    /// Art of the TV show
    public var art: [String: String] = [:]
    /// Year of release of the TV show
    public var year: Int = 0
    /// The remiered date of the TV show
    public var premiered: String = ""
    /// Playcount of the TV show
    var playCount: Int = 0
    /// Runtime of the music video
    public var runtime: Int = 0
    /// An array with cast of the movie
    public var cast: [ActorItem] = []
    /// # Coding keys
    /// All the coding keys for a tvshow item
    enum CodingKeys: String, CodingKey {
        /// The keys
        case title, file, genre, art, premiered
        /// lowerCamelCase
        case playCount = "playcount"
        /// lowerCamelCase
        case tvshowID = "tvshowid"
        /// Use the 'plot' as description
        case description = "plot"
    }
    /// # Calculated stuff
    /// Subtitle of the TV show; not in use
    public var subtitle: String?
}
