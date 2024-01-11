//
//  AudioLibrary+getProperties.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: getProperties

extension AudioLibrary {

    /// Retrieves the values of the music library properties (Kodi API)
    /// - Returns: The properties in a ``Audio/Property/Value`` struct
    public static func getProperties() async -> Audio.Property.Value {
        let kodi: KodiConnector = .shared
        do {
            let request = try await kodi.sendRequest(request: GetProperties())
            return request
        } catch {
            Logger.library.error("Loading audio properties failed with error: \(error.localizedDescription)")
            return Audio.Property.Value()
        }
    }

    /// Retrieves the values of the music library properties (Kodi API)
    fileprivate struct GetProperties: KodiAPI {
        /// The method
        let method = Method.audioLibraryGetProperties
        /// The parameters
        var parameters: Data {
            buildParams(params: Params())
        }
        /// The parameters struct
        struct Params: Encodable {
            /// The album properties
            let properties = Audio.Property.name
        }
        /// The response struct
        typealias Response = Audio.Property.Value
    }
}
