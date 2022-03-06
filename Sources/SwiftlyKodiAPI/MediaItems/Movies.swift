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
        
        /// Build set items here as well
        var setItems = [MediaItem]()
        
        let movieSets = await getMovieSets()
        let request = VideoLibraryGetMovies()
        do {
            let result = try await sendRequest(request: request)
            /// Get the movies that are not part of a set
            var movieItems = result.movies.filter { $0.movieSetID == 0 }
            /// Add set information to the movies that are part of a set
            for movieSet in movieSets {
                /// Get all the movies that are in this set
                let movies = result.movies.filter { $0.movieSetID == movieSet.movieSetID}
                /// Create a new set
                var setItem = MediaItem(id: "set-\(movieSet.movieSetID)",
                                        media: .movieSet,
                                        title: movieSet.title,
                                        subtitle: "\(movies.count) movies",
                                        description: movieSet.description.isEmpty ? "Movie Set" : movieSet.description,
                                        playcount: movieSet.playcount,
                                        movieSetID: movieSet.movieSetID
                )
                /// Use the last movie poster for the set if the set has none
                setItem.poster = movieSet.poster.isEmpty ? movies.last?.poster ?? "" : movieSet.poster
                /// Collect all the genres in this set and add it to the set as `genres` and `details`
                let genres = movies.flatMap { $0.genre }
                                    .removingDuplicates()
                setItem.genres = genres
                setItem.details = genres.joined(separator: "・")
                /// Add the set to the list of sets
                setItems.append(setItem)
                /// Now add some set info to the movies
                for movie in movies {
                    var movieWithSet = movie
                    movieWithSet.movieSetTitle = movieSet.title
                    movieItems.append(movieWithSet)
                }
            }
            return setItems + setMediaItem(items: movieItems, media: .movie)
        } catch {
            /// There are no movies in the library
            print("Loading movies failed with error: \(error)")
            return [MediaItem]()
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
                "dateadded"
            ]
            /// The sort order
            var sort = KodiConnector.SortFields()
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of movies
            let movies: [KodiItem]
        }
    }
}

extension KodiConnector {

    /// Get all the movie sets from the Kodi host
    /// - Returns: All movie sets from the Kodi host
    func getMovieSets() async -> [KodiItem] {
        let request = VideoLibraryGetMovieSets()
        do {
            let result = try await sendRequest(request: request)
            //return setMediaItem(items: result.sets, media: .movieSet)
            return result.sets
        } catch {
            /// There are no sets in the library
            print("Loading movie sets failed with error: \(error)")
            return [KodiItem]()
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
            /// The list of movies
            let sets: [KodiItem]
        }
    }
}
