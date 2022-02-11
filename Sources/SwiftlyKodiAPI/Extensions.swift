//
//  File.swift
//  
//
//  Created by Nick Berendsen on 10/02/2022.
//

import Foundation

extension String {
    
    // MARK: kodiFileUrl (function)
    
    /// Convert internal Kodi path to a full URL
    /// - Returns: A string representing the full file URL
    func kodiFileUrl(media: KodiClient.KodiFile) -> String {
        let host = KodiClient.shared.host
        /// Encoding
        var allowed = CharacterSet.alphanumerics
        allowed.insert(charactersIn: ":-._~") /// as per RFC 3986
        /// Image URL
        let kodiImageAddress = "http://\(host.username):\(host.password)@\(host.ip):\(host.port)/\(media.rawValue)/"
        return kodiImageAddress + self.addingPercentEncoding(withAllowedCharacters: allowed)!
    }
}
