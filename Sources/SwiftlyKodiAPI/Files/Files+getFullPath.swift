//
//  Files+getFullPath.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Files {
    
    /// Convert an internal Kodi path to a full path (SwiftlyKodi API)
    ///
    /// Kodi does not store the full path of a file in the database; it must be converted to a full path
    ///
    /// - Parameters:
    ///   - file: The internal Kodi path
    ///   - type: The ``Files/MediaType``; an image or a file
    /// - Returns: A string with the full path to the file
    public static func getFullPath(file: String, type: Files.MediaType) -> String {
        /// Get the current host
        let host = KodiConnector.shared.host
        /// Encoding
        var allowed = CharacterSet.alphanumerics
        allowed.insert(charactersIn: ":-._~") /// as per RFC 3986
        /// Image URL
        let kodiImageAddress = "http://\(host.username):\(host.password)@\(host.ip):\(host.port)/\(type.rawValue)/"
        return kodiImageAddress + file.addingPercentEncoding(withAllowedCharacters: allowed)!
    }
}
