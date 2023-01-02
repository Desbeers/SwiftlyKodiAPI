//
//  AudioLibrary+getProperties.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

// MARK: getProperties

extension AudioLibrary {

    /// Retrieves the values of the music library properties (Kodi API)
    /// - Returns: The properties in a ``Audio/Property/Value`` struct
    public static func getProperties() async -> Audio.Property.Value {
        let kodi: KodiConnector = .shared
        if let request = try? await kodi.sendRequest(request: GetProperties()) {
            return request
        } else {
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
