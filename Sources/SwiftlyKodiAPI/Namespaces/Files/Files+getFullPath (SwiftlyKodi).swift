//
//  Files+getFullPath.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

extension Files {

    /// Convert an internal Kodi path to a full path (SwiftlyKodi API)
    ///
    /// Kodi does not store the full path of a file in the database; it must be converted to a full path
    ///
    /// - Note: Because of performance, I don't use 'Files.prepareDownload' here
    ///
    /// - Parameters:
    ///   - host: The current ``HostItem``
    ///   - file: The internal Kodi path
    ///   - type: The ``Files/MediaType``; an image or a file
    /// - Returns: A string with the full path to the file
    public static func getFullPath(host: HostItem, file: String, type: Files.MediaType) -> String {
        /// Encoding
        var allowed = CharacterSet.alphanumerics
        allowed.insert(charactersIn: ":-._~") /// as per RFC 3986
        /// Base URL as String
        let kodiImageAddress = "http://\(host.username):\(host.password)@\(host.ip):\(host.port)/\(type.rawValue)/"
        /// Complete URL a s String
        if let path = file.addingPercentEncoding(withAllowedCharacters: allowed) {
            return kodiImageAddress + path
        }
        /// This should not happen
        return kodiImageAddress
    }
}
