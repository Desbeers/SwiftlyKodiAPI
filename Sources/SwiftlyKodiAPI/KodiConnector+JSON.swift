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
            throw JSON.APIError.responseUnsuccessful
              }
        guard let decoded = try? JSONDecoder().decode(JSON.BaseResponse<T.Response>.self, from: data) else {
            debugJsonResponse(data: data)
            throw JSON.APIError.invalidData
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
    

}
