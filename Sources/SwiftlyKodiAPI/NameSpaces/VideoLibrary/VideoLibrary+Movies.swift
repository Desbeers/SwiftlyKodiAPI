//
//  VideoLibrary+Movies.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK:  getMovies

extension VideoLibrary {
    
    /// Retrieve all movies (Kodi API)
    /// - Returns: All movies in an ``Video/Details/Movie`` array
    public static func getMovies() async -> [Video.Details.Movie] {
        let kodi: KodiConnector = .shared
        if let result = try? await kodi.sendRequest(request: GetMovies()) {
            logger("Loaded \(result.movies.count) movies from the Kodi host")
            return result.movies
        }
        /// There are no movies in the library
        return [Video.Details.Movie]()
    }
    
    /// Retrieve all movies (Kodi API)
    fileprivate struct GetMovies: KodiAPI {
        /// The method
        var method = Methods.videoLibraryGetMovies
        /// The parameters
        var parameters: Data {
            buildParams(params: Params())
        }
        /// The request
        struct Params: Encodable {
            /// The properties that we ask from Kodi
            let properties = Video.Fields.movie
            /// The sorting
            let sort = List.Sort(method: .title, order: .ascending)
        }
        /// The response
        struct Response: Decodable {
            /// The list of movies
            let movies: [Video.Details.Movie]
        }
    }
    
}

// MARK:  getMovieDetails

extension VideoLibrary {
    
    /// Retrieve details about a specific movie (Kodi API)
    /// - Parameter movieID: The ID of the movie
    /// - Returns: A ``Video/Details/Movie`` item
    public static func getMovieDetails(movieID: Library.id) async -> Video.Details.Movie {
        let kodi: KodiConnector = .shared
        let request = GetMovieDetails(movieID: movieID)
        do {
            let result = try await kodi.sendRequest(request: request)
            return result.moviedetails
        } catch {
            logger("Loading movie details failed with error: \(error)")
            return Video.Details.Movie()
        }
    }
    
    /// Retrieve details about a specific movie (Kodi API)
    fileprivate struct GetMovieDetails: KodiAPI {
        /// The movie ID
        let movieID: Library.id
        /// The method
        let method = Methods.videoLibraryGetMovieDetails
        /// The parameters we ask for
        var parameters: Data {
            buildParams(params: Params(movieID: movieID))
        }
        /// The parameters struct
        struct Params: Encodable {
            /// The properties that we ask from Kodi
            let properties = Video.Fields.movie
            /// The ID of the movie
            let movieID: Library.id
            /// Coding keys
            enum CodingKeys: String, CodingKey {
                case properties
                case movieID = "movieid"
            }
        }
        /// The response struct
        struct Response: Decodable {
            /// The details of the song
            let moviedetails: Video.Details.Movie
        }
    }
}

// MARK:  setMovieDetails

extension VideoLibrary {
    
    /// Update the given movie with the given details (Kodi API)
    /// - Parameter movie: The ``Video/Details/Movie`` Item
    public static func setMovieDetails(movie: Video.Details.Movie) async {
        let kodi: KodiConnector = .shared
        let message = SetMovieDetails(movie: movie)
        kodi.sendMessage(message: message)
        logger("Details set for '\(movie.title)'")
    }
    
    /// Update the given movie with the given details (Kodi API)
    fileprivate struct SetMovieDetails: KodiAPI {
        /// The movie
        var movie: Video.Details.Movie
        /// The method
        var method = Methods.videoLibrarySetMovieDetails
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(movie: movie))
        }
        /// The parameters struct
        struct Params: Encodable {
            /// Init the params
            init(movie: Video.Details.Movie) {
                self.movieID = movie.movieID
                self.userRating = movie.userRating
                self.playcount = movie.playcount
                self.lastPlayed = movie.lastPlayed
            }
            /// The movie ID
            let movieID: Library.id
            /// The rating of the movie
            let userRating: Int
            /// The playcount of the movie
            let playcount: Int
            /// The last played date
            let lastPlayed: String
            /// Coding keys
            enum CodingKeys: String, CodingKey {
                case movieID = "movieid"
                case userRating = "userrating"
                case playcount
                case lastPlayed = "lastplayed"
            }
        }
        /// The response struct
        struct Response: Decodable { }
    }
    
}
