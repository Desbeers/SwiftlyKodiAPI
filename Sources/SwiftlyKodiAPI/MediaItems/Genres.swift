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
    public func getGenres(type: GenreType) async -> [GenreItem] {
        if type == .all {
            return await getAllGenres()
        } else {
        let request = VideoLibraryGetGenres(type: type)
            do {
                let result = try await sendRequest(request: request)
                return result.genres
            } catch {
                print("Loading genres failed with error: \(error)")
                return [GenreItem]()
            }
        }
    }
    
    func getAllGenres() async -> [GenreItem] {
        
        let movieGenres = await getGenres(type: .movie)
        let tvGenres = await getGenres(type: .tvshow)
        let musicGenres = await getGenres(type: .musicvideo)
        

        
        let allGenres = movieGenres + tvGenres + musicGenres
        
        return allGenres.unique { $0.genreID}

    }
    
    /// Retrieve all genres (Kodi API)
    struct VideoLibraryGetGenres: KodiAPI {
        /// Argument
        var type: GenreType
        /// Method
        var method = Method.videoLibraryGetGenres
        /// The JSON creator
        var parameters: Data {
            var params = Params()
            if type == .tvshow {
                params.type = "tvshow"
            }
            if type == .musicvideo {
                params.type = "musicvideo"
            }
            params.sort = sort(method: .label, order: .ascending)
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
    /// SF symbol of the genre
    public var symbol: String {
        if let genre = GenreIcon(rawValue: label.lowercased()) {
            return genre.symbol
        }
        return "questionmark.circle"
    }
    /// # Coding keys
    /// All the coding keys for a genre item
    enum CodingKeys: String, CodingKey {
        /// The keys
        case label
        /// lowerCamelCase
        case genreID = "genreid"
    }
}

public enum GenreType: String, CaseIterable {
    case all = "All"
    case movie = "Movies"
    case tvshow = "TV shows"
    case musicvideo = "Music"
}

enum GenreIcon: String {
    case adventure
    case cabaret
    case comedy
    case documentary
    
    var symbol: String {
        
        switch self {
            
        case .adventure:
            return "map"
        case .cabaret:
            return "face.smiling"
        case .comedy:
            return "theatermasks"
        case .documentary:
            return "brain"
        }
    }
}
