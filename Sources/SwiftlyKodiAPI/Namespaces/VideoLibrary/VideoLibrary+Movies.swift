//
//  VideoLibrary+Movies.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: getMovies

extension VideoLibrary {

    /// Retrieve all movies (Kodi API)
    /// - Parameter host: The ``HostItem`` for the request
    /// - Returns: All movies in an ``Video/Details/Movie`` array
    public static func getMovies(host: HostItem) async -> [Video.Details.Movie] {
        do {
            let result = try await JSON.sendRequest(request: GetMovies(host: host))
            Logger.library.info("Loaded \(result.movies.count) movies from the Kodi host")
            return result.movies
        } catch {
            Logger.kodiAPI.error("Loading movies failed with error: \(error)")
            return [Video.Details.Movie]()
        }
    }

    /// Retrieve all movies (Kodi API)
    fileprivate struct GetMovies: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        var method = Method.videoLibraryGetMovies
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

// MARK: getMovieDetails

extension VideoLibrary {

    /// Retrieve details about a specific movie (Kodi API)
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - movieID: The ID of the movie
    /// - Returns: A ``Video/Details/Movie`` item
    public static func getMovieDetails(host: HostItem, movieID: Library.ID) async -> Video.Details.Movie {
        let request = GetMovieDetails(host: host, movieID: movieID)
        do {
            let result = try await JSON.sendRequest(request: request)
            return result.moviedetails
        } catch {
            Logger.kodiAPI.error("Loading movie details failed with error: \(error)")
            return Video.Details.Movie()
        }
    }

    /// Retrieve details about a specific movie (Kodi API)
    fileprivate struct GetMovieDetails: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method = Method.videoLibraryGetMovieDetails
        /// The parameters we ask for
        var parameters: Data {
            buildParams(params: Params(movieID: movieID))
        }
        /// The movie ID
        let movieID: Library.ID
        /// The parameters struct
        struct Params: Encodable {
            /// The properties that we ask from Kodi
            let properties = Video.Fields.movie
            /// The ID of the movie
            let movieID: Library.ID
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

// MARK: setMovieDetails

extension VideoLibrary {

    /// Update the given movie with the given details (Kodi API)
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - movie: The ``Video/Details/Movie`` Item
    public static func setMovieDetails(host: HostItem, movie: Video.Details.Movie) async {
        let message = SetMovieDetails(host: host, movie: movie)
        JSON.sendMessage(message: message)
        Logger.library.notice("Details set for '\(movie.title)'")
    }

    /// Update the given movie with the given details (Kodi API)
    fileprivate struct SetMovieDetails: KodiAPI {
        /// The host
        let host: HostItem
        /// The movie
        var movie: Video.Details.Movie
        /// The method
        var method = Method.videoLibrarySetMovieDetails
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
                self.resume = movie.resume
            }
            /// The movie ID
            let movieID: Library.ID
            /// The rating of the movie
            let userRating: Int
            /// The playcount of the movie
            let playcount: Int
            /// The last played date
            let lastPlayed: String
            /// The resume time
            let resume: Video.Resume
            /// Coding keys
            enum CodingKeys: String, CodingKey {
                case movieID = "movieid"
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
