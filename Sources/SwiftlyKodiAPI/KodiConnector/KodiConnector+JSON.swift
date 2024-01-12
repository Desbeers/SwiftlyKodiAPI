//
//  KodiConnector+JSON.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

extension KodiConnector {

    // MARK: JSON stuff

    /// Send a POST request to Kodi
    /// - Parameter request: A prepared JSON request
    /// - Returns: The decoded response
    func sendRequest<T: KodiAPI>(request: T) async throws -> T.Response {
        Logger.kodiAPI.notice("KodiAPI: \(request.method.rawValue, privacy: .public)")
        let (data, response) = try await urlSession.data(for: request.urlRequest(host: host))
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
    func sendMessage<T: KodiAPI>(
        message: T
    ) {
        Logger.kodiAPI.notice("KodiAPI: \(message.method.rawValue)")
        urlSession.dataTask(with: message.urlRequest(host: host)).resume()
    }
}
