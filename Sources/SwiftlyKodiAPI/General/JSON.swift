//
//  JSON.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: JSON stuff

/// All JSON related items
enum JSON {

    /// Network stuff
    static let urlSession = URLSession(configuration: {
        let configuration = URLSessionConfiguration.default
        configuration.waitsForConnectivity = true
        configuration.timeoutIntervalForRequest = 300
        configuration.timeoutIntervalForResource = 120
        return configuration
    }())


    /// Send a POST request to Kodi
    /// - Parameter request: A prepared JSON request
    /// - Returns: The decoded response
    static func sendRequest<T: KodiAPI>(request: T) async throws -> T.Response {
        Logger.kodiAPI.notice("KodiAPI: \(request.method.rawValue, privacy: .public)")
        let (data, response) = try await JSON.urlSession.data(for: request.urlRequest(host: request.host))
        guard
            let httpResponse = response as? HTTPURLResponse,
            httpResponse.statusCode == 200
        else {
            throw JSON.APIError.responseUnsuccessful
        }
        do {
            let decoded = try JSONDecoder().decode(JSON.BaseResponse<T.Response>.self, from: data)
            return decoded.result
        } catch let DecodingError.dataCorrupted(context) {
            Logger.kodiAPI.error("\(context.codingPath)")
        } catch let DecodingError.keyNotFound(key, context) {
            Logger.kodiAPI.error("Key '\(key.description)' not found: \(context.debugDescription)\ncodingPath: \(context.codingPath)")
        } catch let DecodingError.valueNotFound(value, context) {
            Logger.kodiAPI.error("Value '\(value)' not found: \(context.debugDescription)\ncodingPath: \(context.codingPath)")
        } catch let DecodingError.typeMismatch(type, context) {
            Logger.kodiAPI.error("Type '\(type)' mismatch: \(context.debugDescription)\ncodingPath: \(context.codingPath)")
        } catch {
            Logger.kodiAPI.error("Error: \(error.localizedDescription)")
        }
        throw JSON.APIError.invalidData
    }

    /// Send a message to the host, not caring about the response
    /// - Parameter request: The full URL request
    static func sendMessage<T: KodiAPI>(
        message: T
    ) {
        Logger.kodiAPI.notice("KodiAPI: \(message.method.rawValue)")
        JSON.urlSession.dataTask(with: message.urlRequest(host: message.host)).resume()
    }

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
