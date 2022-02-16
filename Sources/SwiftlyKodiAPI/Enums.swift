//
//  KodiArt.swift
//  VideoPlayer
//
//  Created by Nick Berendsen on 01/02/2022.
//

import Foundation

public enum KodiMedia: String, Equatable {
    case all
    case movie
    case movieSet
    case tvshow
    case musicvideo
    // case documentaires
    // case concerts
    // case cabaret
    // case genre(genre: String)
    // case set(setID: Int)
}

public extension KodiClient {
    
    enum KodiFile: String {
        case art = "image"
        case file = "vfs"
    }
    
//    enum KodiMedia: String, Equatable {
//        case all
//        case movie
//        case movieSet
//        case tvshow
//        case musicvideo
//        // case documentaires
//        // case concerts
//        // case cabaret
//        // case genre(genre: String)
//        // case set(setID: Int)
//    }
    

}
