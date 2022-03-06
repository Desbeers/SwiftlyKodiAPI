//
//  Genres.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {
    
    /// Get all genres from the Kodi host
    /// - Returns: All genres from the Kodi host

    func getAllGenres() async -> [MediaItem] {
        
        var genreItems = [MediaItem]()
        
        /// Get the genres for all media types
        let movieGenres = await getGenres(type: .movie)
        let tvGenres = await getGenres(type: .tvshow)
        let musicGenres = await getGenres(type: .musicvideo)
        /// Combine them
        let allGenres = (movieGenres + tvGenres + musicGenres).unique { $0.genreID}
        /// Add them as MediaItem
        for genre in allGenres {
            genreItems.append(MediaItem(id: "genre-\(genre.genreID)",
                                        media: .genre,
                                        title: genre.label,
                                        poster: genre.symbol)
            )
        }
        /// Return them
        return genreItems
    }
    
//    func getAllGenres() async -> [GenreItem] {
//        /// Get the genres for all media types
//        let movieGenres = await getGenres(type: .movie)
//        let tvGenres = await getGenres(type: .tvshow)
//        let musicGenres = await getGenres(type: .musicvideo)
//        /// Combine them
//        let allGenres = movieGenres + tvGenres + musicGenres
//        /// Return them
//        return allGenres.unique { $0.genreID}
//    }

    /// Get all genres from the Kodi host for a specific media type
    /// - Parameter type: The type of Kodi Media
    /// - Returns: All genres for the specific media type
    func getGenres(type: KodiMedia) async -> [GenreItem] {
        let request = VideoLibraryGetGenres(type: type)
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
        /// Argument
        var type: KodiMedia
        /// Method
        var method = Method.videoLibraryGetGenres
        /// The JSON creator
        var parameters: Data {
            var params = Params()
            params.type = type.rawValue
            params.sort = sort(method: .label, order: .ascending)
            return buildParams(params: params)
        }
        /// The request struct
        struct Params: Encodable {
            var type: String = ""
            /// Sort order
            var sort = KodiConnector.SortFields()
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


enum GenreType: String, CaseIterable {
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
