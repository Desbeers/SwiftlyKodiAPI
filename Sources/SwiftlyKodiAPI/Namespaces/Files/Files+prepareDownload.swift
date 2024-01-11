//
//  Files+prepareDownload.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

extension Files {

    /// Provides a way to download a given file (Kodi API)
    /// - Parameter path: The internal Kodi path of the file
    /// - Returns: The properties of the file
    public static func prepareDownload(path: String) async -> Files.Property.Value {
        let kodi: KodiConnector = .shared
        let request = PrepareDownload(path: path)
        do {
            let result = try await kodi.sendRequest(request: request)
            return result
        } catch {
            return Files.Property.Value()
        }
    }

    /// Provides a way to download a given file(Kodi API)
    fileprivate struct PrepareDownload: KodiAPI {
        /// The path
        let path: String
        /// The method
        let method: Method = .filesPrepareDownload
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(path: path))
        }
        /// The parameters struct
        struct Params: Encodable {
            /// The path we ask for
            let path: String
        }
        /// The response struct
        typealias Response = Files.Property.Value
    }
}
