//
//  File.swift
//  
//
//  Created by Nick Berendsen on 16/02/2022.
//

import Foundation

extension GenericItem {
//    /// The kind of media
//    public enum Media: String, Equatable {
//        case movie
//        case movieSet
//        case tvshow
//        case episode
//        case musicvideo
//    }
    /// The coding keys
    enum CodingKeys: String, CodingKey {
        /// The public keys
        case title, subtitle, description, details, art, year, premiered, runtime
        /// The internal keys
        case plot, tagline, genre, artist
    }
}

/// A struct that can be a movie, TV show, episode or Music Video
public struct GenericItem: Codable, Identifiable {
    
    /// Make it indentifiable
    public var id = UUID()
    
    /// The kind of media
    public var media: KodiMedia = .movie
    
    /// The title of the item
    /// - Movie: The movie title
    /// - TV show: The TV show title
    /// - Episode: The TV show title
    /// - Music Video: The artist name
    public var title: String
    
    /// The subtitle of the item
    /// - Movie: The tagline
    /// - TV show: *Not in use*
    /// - Episode: The episode title
    /// - Music Video: The track name
    public var subtitle: String = ""
    
    /// The description of the item
    /// - Movie: The plot
    /// - TV show: The plot
    /// - Episode: The plot
    /// - Music Video: The plot
    public var description: String
    
    /// The details of the item
    /// - Movie: Genre + Year
    /// - TV show: Genre + Year
    /// - Episode: Episode number + Premiered
    /// - Music Video: Genre + Year
    public var details: String = ""
    
    /// Art of the item
    public var art: [String: String] = [:]
    
    /// Year of release of the item
    public var year: Int = 0
    
    /// Premiered date of the item
    public var premiered: String = ""
    
    /// Duration of the item
    public var duration: String = ""
    
    
    /// # Internal variables
    
    /// Location of the item
    var file: String = ""
    
    /// Plot of the item
    var plot: String = ""
    
    /// Genre for the item
    var genre: [String] = []
    
    /// Tagline of the item (movie)
    var tagline: String = ""
    
    /// Tagline of the item (music video)
    var artist: String = ""
    
    /// Runtime of the item
    var runtime: Int = 0
    
}

extension GenericItem {
    /// In an extension so we can still use the memberwise initializer.
    /// - Note: See https://sarunw.com/posts/how-to-preserve-memberwise-initializer/
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        title = try container.decodeIfPresent(String.self, forKey: .title) ?? ""
        /// Subtitle is different for each media kind
        subtitle = try container.decodeIfPresent(String.self, forKey: .tagline) ?? ""
        subtitle = try container.decodeIfPresent([String].self, forKey: .artist)?.joined(separator: "・") ?? ""
        
        description = try container.decodeIfPresent(String.self, forKey: .plot) ?? ""
        genre = try container.decodeIfPresent([String].self, forKey: .genre) ?? []
        
        
        runtime = try container.decodeIfPresent(Int.self, forKey: .runtime) ?? 0
        
        
        /// Calculated stuff
        details = genre.joined(separator: "・")
        
        duration = runtimeToDuration(runtime: runtime)
        
        
    }
    
    func runtimeToDuration(runtime: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute]
        formatter.unitsStyle = .brief
        return formatter.string(from: TimeInterval(runtime))!
    }
}

extension KodiClient {
    
    /// Get all the movies from the Kodi host
    /// - Returns: All the `MovieItem`'s
    public func getGenerics() async -> [GenericItem] {
        var items: [GenericItem] = []
        let movies = VideoLibraryGetGenericMovies()
        let tvshows = VideoLibraryGetGenericTVShows()
        //let episodes = VideoLibraryGetGenericEpisodes()
        let musicvideos = VideoLibraryGetGenericMusicVideos()
        do {
            let movieList = try await sendRequest2(request: movies)
            items += setMediaKind(media: movieList.movies, kind: .movie)
            let tvshowList = try await sendRequest2(request: tvshows)
            items += setMediaKind(media: tvshowList.tvshows, kind: .tvshow)
            //let episodeList = try await sendRequest(request: episodes)
            //items += setMediaKind(media: episodeList.episodes, kind: .episodes)
            let musicvideoList = try await sendRequest2(request: musicvideos)
            items += setMediaKind(media: musicvideoList.musicvideos, kind: .musicvideo)
        } catch {
            /// There are no songs in the library
            print("Loading movies failed with error: \(error)")
            return [GenericItem]()
        }
        return items
    }
    
    func setMediaKind(media: [GenericItem], kind: KodiMedia) -> [GenericItem] {
        var items: [GenericItem] = []
        for item in media {
            var newItem = item
            newItem.media = kind
            items.append(newItem)
        }
        return items
    }
    
    /// Retrieve all movies (Kodi API)
    struct VideoLibraryGetGenericMovies: KodiAPI {
        /// Method
        var method = Method.videoLibraryGetMovies
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
                "sorttitle",
                "file",
                "tagline",
                "plot",
                "genre",
                "art",
                "year",
                "premiered",
                "set",
                "setid",
                "playcount",
                "runtime",
                "cast",
                //"items",
                //"type"
            ]
            /// The sort order
            var sort = KodiClient.SortFields()
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of movies
            let movies: [GenericItem]
        }
    }
    
    /// Retrieve all TV shows (Kodi API)
    struct VideoLibraryGetGenericTVShows: KodiAPI {
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
                "sorttitle",
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
            /// The list of TV shows
            let tvshows: [GenericItem]
        }
    }
    
    /// Retrieve all episodes of a TV show (Kodi API)
    struct VideoLibraryGetGenericEpisodes: KodiAPI {
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
            let episodes: [GenericItem]
        }
    }
    
    /// Retrieve all songs (Kodi API)
    struct VideoLibraryGetGenericMusicVideos: KodiAPI {
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
