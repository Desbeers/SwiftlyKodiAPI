//
//  MovieSets.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK: getMovieSets

extension VideoLibrary {
    
    /// Get all the movies from the Kodi host
    /// - Returns: All movies from the Kodi host
    public static func getMovieSets() async -> [Video.Details.MovieSet] {
        let kodi: KodiConnector = .shared
        if let result = try? await kodi.sendRequest(request: GetMovieSets()) {
            logger("Loaded \(result.sets.count) movie sets from the Kodi host")
            return result.sets
        }
        /// There are no movie sets in the library
        return [Video.Details.MovieSet]()
    }
    
    /// Retrieve all movie sets (Kodi API)
    struct GetMovieSets: KodiAPI {
        /// Method
        var method = Methods.videoLibraryGetMovieSets
        /// The JSON creator
        var parameters: Data {
            buildParams(params: Params())
        }
        /// The request struct
        struct Params: Encodable {
            /// The properties that we ask from Kodi
            let properties = Video.Fields.movieSet
            /// The sort order
            let sort = List.Sort(method: .title, order: .ascending)
        }
        /// The response struct
        struct Response: Decodable {
            /// The list of movie sets
            let sets: [Video.Details.MovieSet]
        }
    }
}

// MARK: getMovieSetDetails

extension VideoLibrary {
    
    /// Get the details of a movie set item
    /// - Parameter movieSetID: The ID of the movie item
    /// - Returns: An updated Media Item
    public static func getMovieSetDetails(movieSetID: Int) async -> MediaItem {
        let kodi: KodiConnector = .shared
        let request = GetMovieSetDetails(movieSetID: movieSetID)
        do {
            let result = try await kodi.sendRequest(request: request)
            /// Make a MediaItem from the KodiResponse and return it
            return kodi.setMediaItem(items: [result.setdetails], media: .movieSet).first ?? MediaItem()
        } catch {
            logger("Loading movie set details failed with error: \(error)")
            return MediaItem()
        }
    }
    
    /// Retrieve details about a specific movie set  (Kodi API)
    struct GetMovieSetDetails: KodiAPI {
        /// Argument: the movie we ask for
        var movieSetID: Int
        /// Method
        var method = Methods.videoLibraryGetMovieSetDetails
        /// The JSON creator
        var parameters: Data {
            /// The parameters we ask for
            var params = Params()
            params.setid = movieSetID
            return buildParams(params: params)
        }
        /// The request struct
        struct Params: Encodable {
            /// The properties that we ask from Kodi
            let properties = Video.Fields.movieSet
            /// The ID of the movie set
            var setid: Int = 0
        }
        /// The response struct
        struct Response: Decodable {
            /// The details of the song
            var setdetails: KodiResponse
        }
    }
    
}

extension MediaItem {
    
    /// Add additional fields to the movie set item
    /// - Note: This is a *slow* function...
    mutating func addMovieSetFields() {
        /// Get all the movies that are in this set
        let movies = KodiConnector.shared.media.filter { $0.media == .movie && $0.movieSetID == self.movieSetID}
        self.itemsCount = movies.count
        self.subtitle = "\(movies.count) movies"
        /// Use the last movie poster for the set if the set has none
        self.poster = self.poster.isEmpty ? movies.last?.poster ?? "" : self.poster
        /// Collect all the genres in this set and add it to the set as `genres` and `details`
        let genres = movies.flatMap { $0.genres }
            .removingDuplicates()
        self.genres = genres
        self.details = genres.joined(separator: "・")
    }
}
