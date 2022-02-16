//
//  KodiMovies.swift
//  VideoPlayer
//
//  Created by Nick Berendsen on 01/02/2022.
//

import Foundation

extension KodiClient {
    
    /// Get all the movies from the Kodi host
    /// - Returns: All the `MovieItem`'s
    public func getMovies() async -> [MovieItem] {
        let request = VideoLibraryGetMovies()
        do {
            let result = try await sendRequest(request: request)
            return result.movies.sorted {
                $0.sortOrder < $1.sortOrder
            }
        } catch {
            /// There are no songs in the library
            print("Loading movies failed with error: \(error)")
            return [MovieItem]()
        }
    }
    
    /// Retrieve all movies (Kodi API)
    struct VideoLibraryGetMovies: KodiAPI {
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
                "cast"
            ]
            /// The sort order
            var sort = KodiClient.SortFields()
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of movies
            let movies: [MovieItem]
        }
    }
}

/// The struct for a movie item
public struct MovieItem: KodiItem, Identifiable, Hashable {
    /// Make it indentifiable
    public var id = UUID()
    /// # Metadata we get from Kodi
    /// Title of the movie
    public var title: String = ""
    /// Sort title of the movie
    public var sortTitle: String = ""
    /// Location of the movie
    public var file: String = ""
    /// Tagline of the movie
    var tagline: String = ""
    /// Description of the movie (is actually the plot)
    public var description: String = ""
    /// An array with the movie genres
    public var genre: [String] = [""]
    /// Art of the movie
    public var art: [String: String] = [:]
    /// Year of release of the movie
    public var year: Int = 0
    /// Premiered date of the movie
    public var premiered: String = ""
    /// Runtime of the movie
    public var runtime: Int = 0
    /// Optional set name of the movie
    public var set: String = ""
    /// Optional set ID  of the movie; 0 if not in a set
    public var setID: Int = 0
    /// Playcount of the movie
    public var playcount: Int = 0
    /// An array with cast of the movie
    public var cast: [ActorItem] = []
    /// # Coding keys
    /// All the coding keys for a movie item
    enum CodingKeys: String, CodingKey {
        /// The keys
        case title, file, tagline, genre, art, year, premiered, set, runtime, cast, playcount
        /// lowerCamelCase
        case setID = "setid"
        /// lowerCamelCase
        case sortTitle = "sorttitle"
        /// Use 'plot' as description
        case description = "plot"
    }
    /// # Calculated stuff
    /// Subtitle of the movie; we use the tagline here
    public var subtitle: String? {
        return tagline.isEmpty ? nil : tagline
    }
    public var sortOrder: String {
        return set.isEmpty ? sortTitle.isEmpty ? title : sortTitle : set
    }
    public var sortSet: String {
        sortTitle.isEmpty ? title : sortTitle
    }
}
