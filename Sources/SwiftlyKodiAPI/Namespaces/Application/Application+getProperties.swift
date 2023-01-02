//
//  Application+getProperty.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

extension Application {

    /// Retrieves the properties of the application (Kodi API)
    /// - Returns: The ``Application/Property/Value`` of the application
    public static func getProperties() async -> Application.Property.Value {
        if let result = try? await KodiConnector.shared.sendRequest(request: GetProperties()) {
            return result
        } else {
            return Application.Property.Value()
        }
    }

    /// Retrieves the values of the given properties (Kodi API)
    fileprivate struct GetProperties: KodiAPI {
        /// The method
        let method = Method.applicationGetProperties
        /// The parameters
        var parameters: Data {
            buildParams(params: Params())
        }
        /// The parameters struct
        struct Params: Encodable {
            /// The properties we ask from Kodi
            let properties = Application.Property.name
        }
        /// The response struct
        typealias Response = Application.Property.Value
    }
}
