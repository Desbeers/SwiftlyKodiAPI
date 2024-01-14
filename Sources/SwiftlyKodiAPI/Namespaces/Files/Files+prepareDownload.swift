//
//  Files+prepareDownload.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

// MARK: prepareDownload

extension Files {

    /// Provides a way to download a given file (Kodi API)
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - path: The internal Kodi path of the file
    /// - Returns: The properties of the file
    public static func prepareDownload(host: HostItem, path: String) async -> Files.Property.Value {
        let request = PrepareDownload(host: host, path: path)
        do {
            let result = try await JSON.sendRequest(request: request)
            return result
        } catch {
            return Files.Property.Value()
        }
    }

    /// Provides a way to download a given file(Kodi API)
    private struct PrepareDownload: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method: Method = .filesPrepareDownload
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(path: path))
        }
        /// The path
        let path: String
        /// The parameters struct
        struct Params: Encodable {
            /// The path we ask for
            let path: String
        }
        /// The response struct
        typealias Response = Files.Property.Value
    }
}
