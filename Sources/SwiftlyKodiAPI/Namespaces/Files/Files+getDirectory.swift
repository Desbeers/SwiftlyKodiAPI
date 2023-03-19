//
//  Files+getDirectory.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

extension Files {

    /// Get the directories and files in the given directory (Kodi API)
    ///
    /// - Parameters:
    ///   - directory: The directory we want to receive
    ///   - media: The kind of ``Files/Media`` we want to receive
    ///
    /// - Returns: All items received in a  ``List/Item/File`` array
    public static func getDirectory(directory: String, media: Files.Media) async -> [List.Item.File] {
        if
            let result = try? await KodiConnector.shared.sendRequest(
                request: GetDirectory(directory: directory, media: media)
            )
        {
            return result.files
        }
        return [List.Item.File]()
    }

    /// Get the directories and files in the given directory (Kodi API)
    fileprivate struct GetDirectory: KodiAPI {
        /// The directory
        let directory: String
        /// The media
        let media: Files.Media
        /// The method
        let method: Method = .filesGetDirectory
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(directory: directory, media: media))
        }
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
