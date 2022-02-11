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
        case movieSet
        case tvshows
        // case documentaires
        // case concerts
        // case cabaret
        // case genre(genre: String)
        // case set(setID: Int)
    }
    

}
