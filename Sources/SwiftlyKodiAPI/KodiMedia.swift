//
//  KodiMedia.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

/// The Kodi media items
public enum KodiMedia: String, Equatable {
    /// All items
    case all
    /// Movies
    case movie
    /// TV shows
    case tvshow
    /// Episodes
    case episode
    /// Music Videos
    case musicvideo
    /// Artists
    case artist
}
