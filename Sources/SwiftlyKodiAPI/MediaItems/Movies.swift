//
//  Movies.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {

    /// Get all the movies from the Kodi host
    /// - Returns: All movies from the Kodi host
    func getMovies() async -> [MediaItem] {
        let request = VideoLibraryGetMovies()
        do {
            let result = try await sendRequest(request: request)
            /// Return the movies
            return setMediaItem(items: result.movies, media: .movie)
        } catch {
            /// There are no movies in the library
            logger("Loading movies failed with error: \(error)")
            return [MediaItem]()
        }
    }
    
    /// Get the details of a movie item
    /// - Parameter movieID: The ID of the movie item
    /// - Returns: An updated Media Item
    func getMovieDetails(movieID: Int) async -> MediaItem {
        let request = VideoLibraryGetMovieDetails(movieID: movieID)
        do {
            let result = try await sendRequest(request: request)
            /// Make a MediaItem from the KodiResponse and return it
            return setMediaItem(items: [result.moviedetails], media: .movie).first ?? MediaItem()
        } catch {
            logger("Loading movie details failed with error: \(error)")
            return MediaItem()
        }
    }
    
    /// Set the details of a movie item
    /// - Parameter movie: The Media Item
    func setMovieDetails(movie: MediaItem) async {
        let message = VideoLibrarySetMovieDetails(movie: movie)
        sendMessage(message: message)
        logger("Details set for '\(movie.title)'")
    }
}

// MARK: Kodi API's

extension KodiConnector {
    
    /// Retrieve all movies (Kodi API)
    struct VideoLibraryGetMovies: KodiAPI {
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
            let sort = List.Sort(method: .title, order: .descending)
        }
        /// The response
        struct Response: Decodable {
            /// The list of movies
            let movies: [KodiResponse]
        }
    }

    /// Retrieve details about a specific movie (Kodi API)
    struct VideoLibraryGetMovieDetails: KodiAPI {
        /// Argument: the movie we ask for
        var movieID: Int
        /// Method
        var method = Methods.videoLibraryGetMovieDetails
        /// The JSON creator
        var parameters: Data {
            /// The parameters we ask for
            var params = Params()
            params.movieid = movieID
            return buildParams(params: params)
        }
        /// The request struct
        struct Params: Encodable {
            /// The properties that we ask from Kodi
            let properties = Video.Fields.movie
            /// The ID of the movie
            var movieid: Int = 0
        }
        /// The response struct
        struct Response: Decodable {
            /// The details of the song
            var moviedetails: KodiResponse
        }
    }
    
    /// Update the given movie with the given details (Kodi API)
    struct VideoLibrarySetMovieDetails: KodiAPI {
        /// Arguments
        var movie: MediaItem
        /// Method
        var method = Methods.videoLibrarySetMovieDetails
        /// The JSON creator
        var parameters: Data {
            /// The parameters
            let params = Params(movie: movie)
            return buildParams(params: params)
        }
        /// The request struct
        /// - Note: The properties we want to set
        struct Params: Encodable {
            internal init(movie: MediaItem) {
                self.movieid = movie.movieID
                self.userrating = movie.rating
                self.playcount = movie.playcount
                self.lastplayed = movie.lastPlayed
            }
            /// The movie ID
            var movieid: Int
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
