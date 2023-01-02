//
//  XBMC+getInfoBooleans.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

// MARK: getInfoBooleans

extension XBMC {

    /// Retrieve info booleans about Kodi and the system (Kodi API)
    ///
    /// - Note: Unlike the 'real Kodi API', this function can only handle one info boolean at the time
    ///
    /// - Returns: True or false for the ``InfoBoolean``
    public static func getInfoBooleans(info: InfoBoolean) async -> Bool {
        logger("Settings.GetSettings")
        let kodi: KodiConnector = .shared
        let request = GetInfoBooleans(boolean: info)
        do {
            let result = try await kodi.sendRequest(request: request)
            if let response = result.first {
                return response.value
            }
            return false
        } catch {
            logger("Loading info booleans failed with error: \(error)")
            return false
        }
    }

    /// The Info Booleans
    public enum InfoBoolean: String {
        case libraryIsScanning = "Library.IsScanning"
    }

    /// Retrieve info booleans about Kodi and the system (Kodi API)
    fileprivate struct GetInfoBooleans: KodiAPI {
        /// The method
        let method: Method = .xbmcGetInfoBooleans
        /// The ``XBMC/InfoBoolean``
        let boolean: InfoBoolean
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(booleans: [boolean.rawValue]))
        }
        /// The parameters struct
        struct Params: Encodable {
            /// The Boolean we want to get
            let booleans: [String]
        }
        /// The response struct
        ///         /// The response struct
        typealias Response = [String: Bool]
//        struct Response: Decodable {
//            [String: Bool]
//            //let settings: [Setting.Details.Base]
//        }
    }
}
