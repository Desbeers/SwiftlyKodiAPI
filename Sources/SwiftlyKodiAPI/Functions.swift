//
//  File.swift
//  
//
//  Created by Nick Berendsen on 06/05/2022.
//

import Foundation

/// Convert an internal Kodi path to a full path
/// - Parameters:
///   - file: The internal Kodi path
///   - type: The type of remote file
/// - Returns: A string with the full path to the file
func getFilePath(file: String, type: FileType) -> String {
    let host = KodiConnector.shared.host
    /// Encoding
    var allowed = CharacterSet.alphanumerics
    allowed.insert(charactersIn: ":-._~") /// as per RFC 3986
    /// Image URL
    let kodiImageAddress = "http://\(host.username):\(host.password)@\(host.ip):\(host.port)/\(type.rawValue)/"
    return kodiImageAddress + file.addingPercentEncoding(withAllowedCharacters: allowed)!
}

/// The types of Kodi remote files
enum FileType: String {
    /// An image; poster, fanart etc...
    case art = "image"
    /// A file, either video or audio
    case file = "vfs"
}
