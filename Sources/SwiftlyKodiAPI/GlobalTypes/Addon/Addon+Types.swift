//
//  Addon+Types.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

public extension Addon {

    /// Addon types {Global Kodi Type)
    enum Types: String, Decodable, Sendable {
        /// Not an addon type
        case none
        /// Unknown addon type
        case unknown
        /// Skin addon
        case xbmcGuiSkin = "xbmc.gui.skin"
        /// Language addon
        case kodiResourceLanguage = "kodi.resource.language"
    }
}
