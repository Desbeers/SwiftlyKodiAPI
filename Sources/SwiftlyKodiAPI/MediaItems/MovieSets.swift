//
//  KodiMovies.swift
//  VideoPlayer
//
//  Created by Nick Berendsen on 01/02/2022.
//

import Foundation

extension KodiClient {
    
    func getSets() async -> [MovieSet] {
        let request = VideoLibraryGetMovieSets2()
        do {
            let result = try await sendRequest(request: request)
            dump(result.sets)
            return result.sets
        } catch {
            /// There are no sets in the library
            print("Loading movie sets failed with error: \(error)")
            return [MovieSet]()
        }
    }
    
    /// Retrieve all movies (Kodi API)
    struct VideoLibraryGetMovieSets2: KodiAPI {
        /// Method
        var method = Method.videoLibraryGetMovieSets
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
                "playcount",
                "art",
                "plot"
            ]
            /// The sort order
            var sort = KodiClient.SortFields()
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of movies
            let sets: [MovieSet]
        }
    }
    
    struct MovieSet: Codable {
        var title: String
        var playcount: Int
        var art: [String: String]
        var plot: String
    }
    
    /// Get all the movies from the Kodi host
    /// - Returns: All the `MovieItem`'s
    public func getMovieSets() async -> [MovieSetItem] {
        let request = VideoLibraryGetMovieSets()
        do {
            let result = try await sendRequest(request: request)
            return result.sets
        } catch {
            /// There are no sets in the library
            print("Loading movie sets failed with error: \(error)")
            return [MovieSetItem]()
        }
    }
    
    /// Retrieve all movies (Kodi API)
    struct VideoLibraryGetMovieSets: KodiAPI {
        /// Method
        var method = Method.videoLibraryGetMovieSets
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
                "playcount",
                "art",
                "plot"
            ]
            /// The sort order
            var sort = KodiClient.SortFields()
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of movies
            let sets: [MovieSetItem]
        }
    }
}

/// The struct for a movie item
public struct MovieSetItem: KodiItem, Identifiable, Hashable {
    /// Make it indentifiable
    public var id = UUID()
    /// # Metadata we get from Kodi
    /// Title of the movie
    public var title: String = ""
    /// Location of the set
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
    /// Optional set name of the movie
    public var set: String = ""
    /// ID  of the set
    public var setID: Int = 0
    /// Playcount of the movie
    public var playcount: Int = 0
    /// Runtime of the music video
    public var runtime: Int = 0
    /// An array with cast of the movie
    public var cast: [ActorItem] = []
    /// # Coding keys
    /// All the coding keys for a movie item
    enum CodingKeys: String, CodingKey {
        /// The keys
        case title, art, playcount
        /// lowerCamelCase
        case setID = "setid"
        /// Use 'plot' as description
        case description = "plot"
    }
    /// # Not in use
    /// Required by protocol
    public var subtitle: String = ""
    /// # Calculated stuff
//    /// Subtitle of the movie; we use the tagline here
//    public var subtitle: String? {
//        return tagline.isEmpty ? nil : tagline
//    }
//    public var sortOrder: String {
//        return set.isEmpty ? title : set
//    }
}
