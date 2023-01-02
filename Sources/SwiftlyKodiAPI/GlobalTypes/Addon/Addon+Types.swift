//
//  Addon+Types.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

public extension Addon {

    /// Addon types {Global Kodi Type)
    enum Types: String, Decodable {
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

/*

 https://kodi.wiki/view/JSON-RPC_API/v12#Addon.Types

 "unknown",
 "xbmc.player.musicviz",
 "xbmc.gui.skin",
 "kodi.pvrclient",
 "kodi.inputstream",
 "kodi.gameclient",
 "kodi.peripheral",
 "xbmc.python.script",
 "xbmc.python.weather",
 "xbmc.subtitle.module",
 "xbmc.python.lyrics",
 "xbmc.metadata.scraper.albums",
 "xbmc.metadata.scraper.artists",
 "xbmc.metadata.scraper.movies",
 "xbmc.metadata.scraper.musicvideos",
 "xbmc.metadata.scraper.tvshows",
 "xbmc.ui.screensaver",
 "xbmc.python.pluginsource",
 "xbmc.addon.repository",
 "xbmc.webinterface",
 "xbmc.service",
 "kodi.audioencoder",
 "kodi.context.item",
 "kodi.audiodecoder",
 "kodi.resource.images",
 "kodi.resource.language",
 "kodi.resource.uisounds",
 "kodi.resource.games",
 "kodi.resource.font",
 "kodi.vfs",
 "kodi.imagedecoder",
 "xbmc.metadata.scraper.library",
 "xbmc.python.library",
 "xbmc.python.module",
 "kodi.game.controller",
 "",
 "xbmc.addon.video",
 "xbmc.addon.audio",
 "xbmc.addon.image",
 "xbmc.addon.executable",
 "kodi.addon.game"

 */
