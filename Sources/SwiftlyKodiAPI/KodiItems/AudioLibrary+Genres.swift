//
//  Genres.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK:  getGenres

extension AudioLibrary {
    
    /// Retrieve all genres
    /// - Returns: All genres
    public static func getGenres() async -> [Library.Details.Genre] {
        
        let kodi: KodiConnector = .shared
        if let result = try? await kodi.sendRequest(request: GetGenres()) {
            logger("Loaded \(result.genres.count) audio genres from the Kodi host")
            return result.genres
        }
        /// There are no audio genres in the library
        return [Library.Details.Genre]()
    }
    
    
    /// Retrieve all genres (Kodi API)
    struct GetGenres: KodiAPI {
        /// Method
        var method = Methods.audioLibraryGetGenres
        /// The JSON creator
        var parameters: Data {
            buildParams(params: Params())
        }
        /// The request struct
        struct Params: Encodable {
            /// The properties that we ask from Kodi
            let properties = Library.Fields.genre
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
