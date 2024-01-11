//
//  Genres.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: getGenres

extension AudioLibrary {

    /// Retrieve all genres (Kodi API)
    /// - Returns: All genres in a ``Library/Details/Genre`` array
    public static func getGenres() async -> [Library.Details.Genre] {
        let kodi: KodiConnector = .shared
        do {
            let result = try await kodi.sendRequest(request: GetGenres())
            Logger.library.info("Loaded \(result.genres.count) audio genres from the Kodi host")
            return result.genres
        } catch {
            Logger.library.error("Loading audio genres failed with error: \(error.localizedDescription)")
            return [Library.Details.Genre]()
        }
    }

    /// Retrieve all genres (Kodi API)
    fileprivate struct GetGenres: KodiAPI {
        /// The method
        let method = Method.audioLibraryGetGenres
        /// The parameters
        var parameters: Data {
            buildParams(params: Params())
        }
        /// The parameters struct
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
