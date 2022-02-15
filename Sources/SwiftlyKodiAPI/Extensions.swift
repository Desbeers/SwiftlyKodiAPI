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

extension Sequence {
    func unique<T: Hashable>(by taggingHandler: (_ element: Self.Iterator.Element) -> T) -> [Self.Iterator.Element] {
        var knownTags = Set<T>()
        
        return self.filter { element -> Bool in
            let tag = taggingHandler(element)
            
            if !knownTags.contains(tag) {
                knownTags.insert(tag)
                return true
            }
            
            return false
        }
    }
}
