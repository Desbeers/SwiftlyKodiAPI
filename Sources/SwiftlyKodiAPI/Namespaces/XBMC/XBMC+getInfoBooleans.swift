//
//  XBMC+getInfoBooleans.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: getInfoBooleans

extension XBMC {

    /// Retrieve info booleans about Kodi and the system (Kodi API)
    /// - Parameter host: The ``HostItem`` for the request
    /// - Returns: True or false for the ``InfoBoolean``
    /// - Note: Unlike the 'real Kodi API', this function can only handle one info boolean at the time
    public static func getInfoBooleans(host: HostItem, info: InfoBoolean) async -> Bool {
        let request = GetInfoBooleans(host: host, boolean: info)
        do {
            let result = try await JSON.sendRequest(request: request)
            if let response = result.first {
                return response.value
            }
            return false
        } catch {
            Logger.kodiAPI.error("Loading info booleans failed with error: \(error)")
            return false
        }
    }

    /// The Info Booleans
    public enum InfoBoolean: String {
        case libraryIsScanning = "Library.IsScanning"
    }

    /// Retrieve info booleans about Kodi and the system (Kodi API)
    fileprivate struct GetInfoBooleans: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method: Method = .xbmcGetInfoBooleans
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(booleans: [boolean.rawValue]))
        }
        /// The ``XBMC/InfoBoolean``
        let boolean: InfoBoolean
        /// The parameters struct
        struct Params: Encodable {
            /// The Boolean we want to get
            let booleans: [String]
        }
        /// The response struct
        typealias Response = [String: Bool]
    }
}
