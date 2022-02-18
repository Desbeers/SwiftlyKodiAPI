//
//  Files.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension String {

    /// Convert an internal Kodi path to a full URL
    /// - Returns: A string representing the full file URL
    func kodiFileUrl(media: KodiFile) -> String {
        let host = KodiConnector.shared.host
        /// Encoding
        var allowed = CharacterSet.alphanumerics
        allowed.insert(charactersIn: ":-._~") /// as per RFC 3986
        /// Image URL
        let kodiImageAddress = "http://\(host.username):\(host.password)@\(host.ip):\(host.port)/\(media.rawValue)/"
        return kodiImageAddress + self.addingPercentEncoding(withAllowedCharacters: allowed)!
    }
}

/// The types of Kodi remote files
/// - Note: The API does not give a full URL
enum KodiFile: String {
    /// An image; poster, fanart etc...
    case art = "image"
    /// A file, either video or audio
    case file = "vfs"
}
