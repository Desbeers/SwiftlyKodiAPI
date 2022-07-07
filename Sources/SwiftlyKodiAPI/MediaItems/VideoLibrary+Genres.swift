//
//  Genres.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK:  getGenres

extension VideoLibrary {
    
    /// Get all video genres from the Kodi host for a specific media type
    /// - Parameter type: The type of Kodi Media
    /// - Returns: All genres for the specific media type

    public static func getGenres(type: Library.Media) async -> [Library.Details.Genre] {
        
        let kodi: KodiConnector = .shared
        if let result = try? await kodi.sendRequest(request: GetGenres(type: type)) {
            logger("Loaded \(result.genres.count) \(type) genres from the Kodi host")
            return result.genres
        }
        /// There are no genres of this type in the library
        return [Library.Details.Genre]()
    }
    
//    public static func getGenres(type: Library.Media) async -> [MediaItem] {
//        let kodi: KodiConnector = .shared
//        let request = GetGenres(type: type)
//        var genreItems = [MediaItem]()
//        do {
//            let result = try await kodi.sendRequest(request: request)
//            logger("Loaded \(result.genres.count) genres from the Kodi host")
//            /// Add them as a MediaItem
//            for genre in result.genres {
//                genreItems.append(MediaItem(id: "genre-\(genre.genreID)",
//                                            media: .genre,
//                                            title: genre.title)
//                )
//            }
//            return genreItems
//        } catch {
//            logger("Loading genres failed with error: \(error)")
//            return genreItems
//        }
//    }
    
    
    /// Retrieve all genres (Kodi API)
    struct GetGenres: KodiAPI {
        /// Argument
        var type: Library.Media
        /// Method
        var method = Methods.videoLibraryGetGenres
        /// The JSON creator
        var parameters: Data {
            var params = Params()
            params.type = type.rawValue
            return buildParams(params: params)
        }
        /// The request struct
        struct Params: Encodable {
            /// The properties that we ask from Kodi
            let properties = Library.Fields.genre
            var type: String = ""
            /// Sort order
            let sort = List.Sort(method: .label, order: .ascending)
        }
        /// The response struct
        struct Response: Decodable {
            /// A list with genres
            let genres: [Library.Details.Genre]
        }
    }
}


