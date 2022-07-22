//
//  VideoLibrary+Genres.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK:  getGenres

extension VideoLibrary {
    
    /// Retrieve all genres (Kodi API)
    /// - Parameter type: The type of ``Library/Media``
    /// - Returns: All genres in a ``Library/Details/Genre`` array

    public static func getGenres(type: Library.Media) async -> [Library.Details.Genre] {
        
        let kodi: KodiConnector = .shared
        if let result = try? await kodi.sendRequest(request: GetGenres(type: type)) {
            logger("Loaded \(result.genres.count) \(type) genres from the Kodi host")
            return result.genres
        }
        /// There are no genres of this type in the library
        return [Library.Details.Genre]()
    }
    
    /// Retrieve all genres (Kodi API)
    fileprivate struct GetGenres: KodiAPI {
        /// The media type
        let type: Library.Media
        /// The method
        let method = Methods.videoLibraryGetGenres
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(type: type))
        }
        /// The parameters struct
        struct Params: Encodable {
            /// The properties that we ask from Kodi
            let properties = Library.Fields.genre
            let type: Library.Media
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


