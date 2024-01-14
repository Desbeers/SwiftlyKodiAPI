//
//  Files+getDirectory.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

// MARK: GetDirectory

extension Files {

    /// Get the directories and files in the given directory (Kodi API)
    /// - Parameters:
    ///   - host: The ``HostItem`` for the request
    ///   - directory: The directory we want to receive
    ///   - media: The kind of ``Files/Media`` we want to receive
    /// - Returns: All items received in a ``List/Item/File`` array
    public static func getDirectory(host: HostItem, directory: String, media: Files.Media) async -> [List.Item.File] {
        let request = GetDirectory(host: host, directory: directory, media: media)
        do {
            let result = try await JSON.sendRequest(request: request)
            return result.files
        } catch {
            return [List.Item.File]()
        }
    }

    /// Get the directories and files in the given directory (Kodi API)
    private struct GetDirectory: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method: Method = .filesGetDirectory
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(directory: directory, media: media))
        }
        /// The directory
        let directory: String
        /// The media
        let media: Files.Media
        /// The parameters struct
        struct Params: Encodable {
            /// The directory we ask for
            let directory: String
            /// Media type we ask for
            let media: Files.Media
            /// Properties we ask for
            let properties = List.Fields.files
        }
        /// The response struct
        struct Response: Decodable {
            let files: [List.Item.File]
        }
    }
}
