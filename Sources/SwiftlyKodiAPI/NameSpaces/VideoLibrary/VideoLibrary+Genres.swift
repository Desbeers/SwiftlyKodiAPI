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


