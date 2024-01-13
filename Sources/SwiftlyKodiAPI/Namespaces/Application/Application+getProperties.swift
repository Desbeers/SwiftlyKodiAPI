//
//  Application+getProperty.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

extension Application {

    /// Retrieves the properties of the application (Kodi API)
    /// - Returns: The ``Application/Property/Value`` of the application
    public static func getProperties(host: HostItem) async -> Application.Property.Value {
        do { 
            let result = try await JSON.sendRequest(request: GetProperties(host: host))
            return result
        } catch {
            Logger.library.error("Loading application property failed with error: \(error.localizedDescription)")
            return Application.Property.Value()
        }
    }

    /// Retrieves the values of the given properties (Kodi API)
    fileprivate struct GetProperties: KodiAPI {
        /// The host
        let host: HostItem
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
