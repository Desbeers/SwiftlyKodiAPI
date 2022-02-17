//
//  Movies.swift
//  SwiftlyKodiAPI
//
// © 2021 Nick Berendsen
//

import Foundation

extension KodiClient {

    /// Get all the movies from the Kodi host
    /// - Returns: All the ``KodiItem``'s that is a movie
    func getMovies() async -> [KodiItem] {
        let request = VideoLibraryGetMovies()
        let movieSets = await getMovieSets()
        do {
            let result = try await sendRequest(request: request)
            /// Get the movies tat are not part of a set
            var movieItems = result.movies.filter { $0.setID == 0 }
            /// Add set information to the movies
            for movieSet in movieSets {
                let movies = result.movies.filter { $0.setID == movieSet.setID} .sortByYearAndTitle()
                for movie in movies {
                    var movieWithSet = movie
                    movieWithSet.setInfo = movieSet
                    movieWithSet.setInfo.movies = movies.map { $0.title}
                    .joined(separator: "・")
                    movieWithSet.setInfo.details = "\(movies.count)"
                    movieItems.append(movieWithSet)
                }
            }
            return setMediaKind(items: movieItems, media: .movie)
        } catch {
            /// There are no movies in the library
            print("Loading movies failed with error: \(error)")
            return [KodiItem]()
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
            let movies: [KodiItem]
        }
    }
}

extension KodiClient {
    
    func getMovieSets() async -> [MovieSetItem] {
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

public struct MovieSetItem: Codable {
    public var setID: Int = 0
    public var title: String = ""
    public var playcount: Int = 0
    public var art: [String: String] = [:]
    public var description: String = ""
    /// The coding keys
    enum CodingKeys: String, CodingKey {
        case title, playcount, art
        /// Description is plot
        case description = "plot"
        /// Camel Case
        case setID = "setid"
    }
    /// The poster of the movie set
    public var poster: String {
        if let posterArt = art["poster"] {
            return posterArt.kodiFileUrl(media: .art)
        }
        return ""
    }
    /// The movie titles in the set
    public var movies: String = ""
    /// The details of the movies in the set
    public var details: String = ""
}
