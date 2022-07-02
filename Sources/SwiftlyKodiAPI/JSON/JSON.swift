//
//  JSON.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

/// All JSON related items
enum JSON {
    
    /// Base for JSON parameters
    struct BaseParameters<T: Encodable>: Encodable {
        /// The JSON version
        let jsonrpc = "2.0"
        /// The Kodi method to use
        var method: String
        /// The parameters
        var params: T
        /// The ID
        var id: String
    }
    
    /// Base for JSON response
    struct BaseResponse<T: Decodable>: Decodable {
        var method: String
        /// The result variable of a response
        var result: T
        /// Coding Keys
        enum CodingKeys: String, CodingKey {
            /// The keys
            case result
            /// ID is a reserved word
            case method = "id"
        }
    }
    
    /// List of possible errors
    enum APIError: Error {
        /// Invalid data
        case invalidData
        /// Unsuccesfull response
        case responseUnsuccessful
    }
}
