//
//  MovieSets.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

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
