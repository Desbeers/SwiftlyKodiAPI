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
    func getMovies(movieSets: inout [MediaItem]) async -> [MediaItem] {
        let request = VideoLibraryGetMovies()
        do {
            let result = try await sendRequest(request: request)
            /// Get the movies that are not part of a set
            var movieItems = result.movies.filter { $0.movieSetID == 0 }
            /// Loop over all movie sets to add some info
            for (index, movieSet) in movieSets.enumerated() {
                /// Get all the movies that are in this set
                let movies = result.movies.filter { $0.movieSetID == movieSet.movieSetID}
                /// Set some additional info
                movieSets[index].itemsCount = movies.count
                movieSets[index].subtitle = "\(movies.count) movies"
                /// Use the last movie poster for the set if the set has none
                movieSets[index].poster = movieSet.poster.isEmpty ? movies.last?.poster ?? "" : movieSet.poster
                /// Collect all the genres in this set and add it to the set as `genres` and `details`
                let genres = movies.flatMap { $0.genre }
                                    .removingDuplicates()
                movieSets[index].genres = genres
                movieSets[index].details = genres.joined(separator: "・")
                /// Add the movies to the list of movies
                movieItems += movies
            }
            /// Return the movies
            return setMediaItem(items: movieItems, media: .movie)
        } catch {
            /// There are no movies in the library
            logger("Loading movies failed with error: \(error)")
            return [MediaItem]()
        }
    }
    
    /// Get the details of a movie
    /// - Parameter movieID: The ID of the movie item
    /// - Returns: An updated Media Item
    func getMovieDetails(movieID: Int) async -> MediaItem {
        let request = VideoLibraryGetMovieDetails(movieID: movieID)
        do {
            let result = try await sendRequest(request: request)
            /// Make a MediaItem from the KodiResonse and return it
            return setMediaItem(items: [result.moviedetails], media: .movie).first ?? MediaItem()
        } catch {
            logger("Loading movie details failed with error: \(error)")
            return MediaItem()
        }
    }
    
    /// Update the details of a movie
    /// - Parameter movie: The Media Item
    func setMovieDetails(movie: MediaItem) async {
        let message = VideoLibrarySetMovieDetails(movie: movie)
        sendMessage(message: message)
        logger("Details set for '\(movie.title)'")
    }
}

// MARK: Movie Sets

extension KodiConnector {

    /// Get all the movie sets from the Kodi host
    /// - Returns: All movie sets from the Kodi host
    func getMovieSets() async -> [MediaItem] {
        let request = VideoLibraryGetMovieSets()
        do {
            let result = try await sendRequest(request: request)
            return setMediaItem(items: result.sets, media: .movieSet)
        } catch {
            /// There are no sets in the library
            logger("Loading movie sets failed with error: \(error)")
            return [MediaItem]()
        }
    }
}

// MARK: Kodi API's

extension KodiConnector {
    
    /// The Movie properties we ask from Kodi
    static var VideoFieldsMovie = [
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
        "dateadded",
        "lastplayed"
    ]
    
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
            let properties = VideoFieldsMovie
            /// The sort order
            var sort = KodiConnector.SortFields()
        }
        /// The response struct
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
        var method = Method.videoLibraryGetMovieDetails
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
            let properties = KodiConnector.VideoFieldsMovie
            /// The ID of the movie
            var movieid: Int = 0
        }
        /// The response struct
        struct Response: Decodable {
            /// The details of the song
            var moviedetails: KodiResponse
        }
    }
    
    /// Retrieve all movie sets (Kodi API)
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
            var sort = KodiConnector.SortFields()
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of movie sets
            let sets: [KodiResponse]
        }
    }
    
    /// Update the given movie with the given details (Kodi API)
    struct VideoLibrarySetMovieDetails: KodiAPI {
        /// Arguments
        var movie: MediaItem
        /// Method
        var method = Method.videoLibrarySetMovieDetails
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
