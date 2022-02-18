//
//  Art.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

enum KodiArt {
    case poster
    case fanart
}

func getSpecificArt(art: [String: String], type: KodiArt) -> String {
    
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
    }
    return ""
}
