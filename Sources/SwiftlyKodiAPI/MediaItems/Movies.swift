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
    func getMovies() async -> [KodiItem] {
        let request = VideoLibraryGetMovies()
        let movieSets = await getMovieSets()
        do {
            let result = try await sendRequest(request: request)
            
            for movie in result.movies {
                /// Add this tv show to the Kodi library
                kodiLibrary.append(KodiLibraryItem(title: movie.title,
                                                   media: .movie,
                                                   movieID: movie.movieID,
                                                   setID: movie.setID
                                                  )
                )
            }
            
            /// FIX BELOW!!!!!
            
            /// Get the movies that are not part of a set
            var movieItems = result.movies.filter { $0.setID == 0 }
            /// Add set information to the movies
            for movieSet in movieSets {
                let movies = result.movies.filter { $0.setID == movieSet.setID} .sortByYearAndTitle()
                
                self.movies = result.movies
                
                for movie in movies {
                    
                    
                    var movieWithSet = movie
                    movieWithSet.setInfo = movieSet
                    movieWithSet.setInfo.movies = movies.map { $0.title}
                    .joined(separator: "・")
                    movieWithSet.setInfo.count = movies.count
                    movieWithSet.setInfo.genres = movies.flatMap { $0.genre }
                    .removingDuplicates()
                    .joined(separator: "・")
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
    
    func filterMovies(_ filter: KodiFilter) -> [KodiItem] {
        if let setID = filter.setID {
            print("Have Set")
            print(setID)
            let moviesID = kodiLibrary
                .filter { $0.media == .movie && $0.setID == setID }
                .map { $0.movieID }
            
            dump(moviesID)
            
            return movies
                .filter {moviesID.contains($0.movieID)}
                .sortByYearAndTitle()

        } else {
            
            let moviesID = kodiLibrary
                .filter { $0.media == .movie }
                .map { $0.movieID }
            

            return movies
                .filter {moviesID.contains($0.movieID)}
                .uniqueSet()
                .sortBySetAndTitle()
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
    func getMovieSets() async -> [KodiItem.MovieSetItem] {
        let request = VideoLibraryGetMovieSets()
        do {
            let result = try await sendRequest(request: request)
            return result.sets
        } catch {
            /// There are no sets in the library
            print("Loading movie sets failed with error: \(error)")
            return [KodiItem.MovieSetItem]()
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
            let sets: [KodiItem.MovieSetItem]
        }
    }
}

extension Array where Element == KodiLibraryItem {

    public func filter(_ filter: KodiFilter) -> [KodiItem] {
        return KodiConnector.shared.filter(filter)
    }
}
