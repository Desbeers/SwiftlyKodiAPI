//
//  Movies.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK:  getMovies

extension VideoLibrary {
    
    /// Get all the movies from the Kodi host
    /// - Returns: All movies from the Kodi host
    public static func getMovies() async -> [MediaItem] {
        let kodi: KodiConnector = .shared
        if let result = try? await kodi.sendRequest(request: GetMovies()) {
            logger("Loaded \(result.movies.count) movies from the Kodi host")
            return kodi.setMediaItem(items: result.movies, media: .movie)
        }
        /// There are no movies in the library
        return [MediaItem]()
    }
    
    /// Retrieve all movies (Kodi API)
    struct GetMovies: KodiAPI {
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
    
}

// MARK:  getMovieDetails

extension VideoLibrary {
    
    /// Get the details of a movie item
    /// - Parameter movieID: The ID of the movie item
    /// - Returns: An updated Media Item
    public static func getMovieDetails(movieID: Int) async -> MediaItem {
        let kodi: KodiConnector = .shared
        let request = VideoLibraryGetMovieDetails(movieID: movieID)
        do {
            let result = try await kodi.sendRequest(request: request)
            /// Make a MediaItem from the KodiResponse and return it
            return kodi.setMediaItem(items: [result.moviedetails], media: .movie).first ?? MediaItem()
        } catch {
            logger("Loading movie details failed with error: \(error)")
            return MediaItem()
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
}

// MARK:  setMovieDetails

extension VideoLibrary {
    
    /// Set the details of a movie item
    /// - Parameter movie: The movie Media Item
    public static func setMovieDetails(movie: MediaItem) async {
        let kodi: KodiConnector = .shared
        let message = VideoLibrarySetMovieDetails(movie: movie)
        kodi.sendMessage(message: message)
        logger("Details set for '\(movie.title)'")
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
