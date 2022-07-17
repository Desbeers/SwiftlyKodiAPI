//
//  Files+getDirectory.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Files {
    
    /// Get the directories and files in the given directory
    public static func getDirectory(directory: String, media: Files.Media) async -> [List.Item.File] {
        
        if let result = try? await KodiConnector.shared.sendRequest(request: GetDirectory(directory: directory, media: media)) {
            return result.files
        }
        return [List.Item.File]()
    }
    
    /// Get the directories and files in the given directory (Kodi API)
    struct GetDirectory: KodiAPI {
        /// The directory
        var directory: String
        /// The media
        var media: Files.Media
        /// Method
        let method: Methods = .filesGetDirectory
        /// The JSON creator
        var parameters: Data {
            buildParams(params: Params(directory: directory, media: media))
        }
        /// The request struct
        struct Params: Encodable {
            /// The directory we ask for
            let directory: String
            /// Media type we ask for
            let media: Files.Media
        }
        /// The response struct
        struct Response: Decodable {
            let files: [List.Item.File]
        }
    }
    
}
