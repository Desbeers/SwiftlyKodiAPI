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
    /// - Parameter host: The ``HostItem`` for the request
    /// - Returns: The properties in a ``Audio/Property/Value`` struct
    public static func getProperties(host: HostItem) async -> Audio.Property.Value {
        do {
            let request = try await JSON.sendRequest(request: GetProperties(host: host))
            return request
        } catch {
            Logger.library.error("Loading audio properties failed with error: \(error.localizedDescription)")
            return Audio.Property.Value()
        }
    }

    /// Retrieves the values of the music library properties (Kodi API)
    private struct GetProperties: KodiAPI {
        /// The host
        let host: HostItem
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
