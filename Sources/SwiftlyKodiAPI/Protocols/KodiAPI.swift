//
//  KodiAPI.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

/// A protocol to define a Kodi API request (SwiftlyKodi Type)
protocol KodiAPI {
    /// The response given by the struct
    associatedtype Response: Decodable
    /// The httpBody for the request
    var parameters: Data { get }
    /// The method to use
    var method: Method { get }
    /// The Kodi host
    var host: HostItem { get }
}

extension KodiAPI {

    /// Build the JSON parameters
    /// - Returns: `Data` formatted JSON request
    func buildParams<T: Encodable>(params: T) -> Data {
        let parameters = JSON
            .BaseParameters(
                method: method.rawValue,
                params: params.self,
                id: host.ip
            )
        do {
            return try JSONEncoder().encode(parameters)
        } catch {
            return Data()
        }
    }
}

extension KodiAPI {

    /// Build the URL request
    /// - Parameter host: The curren ``HostItem``
    /// - Returns: A complete `URLRequest`
    func urlRequest(host: HostItem) -> URLRequest {
        var request = URLRequest(
            // swiftlint:disable:next force_unwrapping
            url: URL(string: "http://\(host.username):\(host.password)@\(host.ip):\(host.port)/jsonrpc")!
        )
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = parameters
        return request
    }
}
