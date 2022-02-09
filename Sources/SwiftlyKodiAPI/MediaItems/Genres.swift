//
//  KodiGenres.swift
//  VideoPlayer
//
//  Created by Nick Berendsen on 02/02/2022.
//

import Foundation

extension KodiClient {

    /// Get all genres from the Kodi host
    /// - Parameter reload: Force a reload or else it will try to load it from the  cache
    /// - Returns: True when loaded; else false
    public func getGenres() async -> [GenreItem] {
            let request = VideoLibraryGetGenres()
            do {
                let result = try await sendRequest(request: request)
                return result.genres
            } catch {
                print("Loading genres failed with error: \(error)")
                return [GenreItem]()
            }
    }
    
    /// Retrieve all genres (Kodi API)
    struct VideoLibraryGetGenres: KodiAPI {
        /// Method
        var method = Method.videoLibraryGetGenres
        /// The JSON creator
        var parameters: Data {
            var params = Params()
            params.sort.method = KodiClient.SortMethod.label.string()
            params.sort.order = KodiClient.SortMethod.ascending.string()
            return buildParams(params: params)
        }
        /// The request struct
        struct Params: Encodable {
            var type: String = "movie"
            /// Sort order
            var sort = KodiClient.SortFields()
        }
        /// The response struct
        struct Response: Decodable {
            /// A list with genres
            let genres: [GenreItem]
        }
    }
}

/// The struct for a genre item
public struct GenreItem: Codable, Identifiable, Hashable {
    public var id = UUID()
    /// # Metadata we get from Kodi
    /// The genre ID
    public var genreID: Int = 0
    /// Label of the genre
    public var label: String = ""
    /// # Coding keys
    /// All the coding keys for a genre item
    enum CodingKeys: String, CodingKey {
        /// The keys
        case label
        /// lowerCamelCase
        case genreID = "genreid"
    }
}
