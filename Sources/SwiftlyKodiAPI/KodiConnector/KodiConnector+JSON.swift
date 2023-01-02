//
//  KodiConnector+JSON.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
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
            throw JSON.APIError.responseUnsuccessful
              }
        do {
            // debugJsonResponse(data: data)
            let decoded = try JSONDecoder().decode(JSON.BaseResponse<T.Response>.self, from: data)
            return decoded.result
            } catch let DecodingError.dataCorrupted(context) {
                print(context)
                debugJsonResponse(data: data)
            } catch let DecodingError.keyNotFound(key, context) {
                print("Key '\(key)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
                debugJsonResponse(data: data)
            } catch let DecodingError.valueNotFound(value, context) {
                print("Value '\(value)' not found:", context.debugDescription)
                print("codingPath:", context.codingPath)
            } catch let DecodingError.typeMismatch(type, context) {
                print("Type '\(type)' mismatch:", context.debugDescription)
                print("codingPath:", context.codingPath)
                debugJsonResponse(data: data)
            } catch {
                print("error: ", error)
            }
        throw JSON.APIError.invalidData
    }

    /// Send a message to the host, not caring about the response
    /// - Parameter request: The full URL request
    func sendMessage<T: KodiAPI>(

        message: T
    ) {
        urlSession.dataTask(with: message.urlRequest).resume()
    }

    public func test() {

    }

}
