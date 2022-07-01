//
//  KodiConnector+JSON.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {
    
    // MARK: JSON stuff
    
    /// Send a POST request to Kodi
    /// - Parameter request: A prepared JSON request
    /// - Returns: The decoded response
    func sendRequest<T: KodiAPI>(request: T) async throws -> T.Response {
        let (data, response) = try await urlSession.data(for: request.urlRequest)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
                  throw APIError.responseUnsuccessful
              }
        guard let decoded = try? JSONDecoder().decode(BaseResponse<T.Response>.self, from: data) else {
            debugJsonResponse(data: data)
            throw APIError.invalidData
        }
        // debugJsonResponse(data: data)
        return decoded.result
    }
    
    /// Send a message to the host, not caring about the response
    /// - Parameter request: The full URL request
    func sendMessage<T: KodiAPI>(

        message: T
    ) {
        urlSession.dataTask(with: message.urlRequest).resume()
    }
    
    /// Base for JSON parameter struct
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
    
    /// Base for response struct
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
