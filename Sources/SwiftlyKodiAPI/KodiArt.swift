//
//  KodiArt.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// The types media art
enum ArtType {
    /// Poster
    /// - Note: Poster will fallback to thumbnail or thumb if needed
    case poster
    /// Fanart
    /// - Note: Fanart will fallback to poster if needed
    case fanart
}

/// Get a specific art item from the collection
/// - Parameters:
///   - art: The art collection
///   - type: The kind of ard we want
/// - Returns: An internal Kodi URL for the art
func getSpecificArt(art: [String: String], type: ArtType) -> String {
    switch type {
    case .poster:
        if let posterArt = art["poster"] {
            return posterArt.kodiFileUrl(media: .art)
        }
        if let posterArt = art["season.poster"] {
            return posterArt.kodiFileUrl(media: .art)
        }
        if let posterArt = art["thumbnail"] {
            return posterArt.kodiFileUrl(media: .art)
        }
        if let posterArt = art["thumb"] {
            return posterArt.kodiFileUrl(media: .art)
        }
    case .fanart:
        if let posterArt = art["fanart"] {
            return posterArt.kodiFileUrl(media: .art)
        }
        if let posterArt = art["tvshow.fanart"] {
            return posterArt.kodiFileUrl(media: .art)
        }
        // Fallback to poster
        return getSpecificArt(art: art, type: .poster)
    }
    return ""
}
