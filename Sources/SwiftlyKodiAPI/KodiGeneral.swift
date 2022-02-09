//
//  KodiArt.swift
//  VideoPlayer
//
//  Created by Nick Berendsen on 01/02/2022.
//

import Foundation

public extension KodiClient {
    
    enum KodiFile: String {
        case art = "image"
        case file = "vfs"
    }
    
    enum KodiMedia: Equatable {
        case all
        case movies
        // case documentaires
        // case concerts
        // case cabaret
        // case genre(genre: String)
        // case set(setID: Int)
    }
    
    struct KodiMediaFilter {
        public var set: Int?
        public var genre: String?
        public var search: String?
        public var media: KodiMedia = .movies
        public init(set: Int? = nil, genre: String? = nil, search: String? = nil, media: KodiClient.KodiMedia = .movies) {
            self.set = set
            self.genre = genre
            self.search = search
            self.media = media
        }
    }
    
}
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
