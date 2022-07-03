//
//  Files.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

/// All Files related items
public enum Files {
    /// Just a placeholder
}

extension Files {
    /// Media types
    public enum Media: String, Codable {
        case video
        case music
        case pictures
        case files
        case programs
        case all
        case none
    }
}

extension Files {
    /// Media type
    enum MediaType: String {
        /// An image; poster, fanart etc...
        case art = "image"
        /// A file, either video or audio
        case file = "vfs"
    }
}

extension Files {
    /// Convert an internal Kodi path to a full path
    /// - Parameters:
    ///   - file: The internal Kodi path
    ///   - type: The media type
    /// - Returns: A string with the full path to the file
    static func getFullPath(file: String, type: Files.MediaType) -> String {
        let host = KodiConnector.shared.host
        /// Encoding
        var allowed = CharacterSet.alphanumerics
        allowed.insert(charactersIn: ":-._~") /// as per RFC 3986
        /// Image URL
        let kodiImageAddress = "http://\(host.username):\(host.password)@\(host.ip):\(host.port)/\(type.rawValue)/"
        return kodiImageAddress + file.addingPercentEncoding(withAllowedCharacters: allowed)!
    }
}
