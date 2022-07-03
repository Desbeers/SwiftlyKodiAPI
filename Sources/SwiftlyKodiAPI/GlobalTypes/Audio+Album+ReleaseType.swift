//
//  Audio+Album+ReleaseType.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//
import Foundation

public extension Audio {
    
    /// All Audio details related items
    enum Album {
        /// Just a placeholder
    }
}

public extension Audio.Album {
    
    enum ReleaseType: String, Codable {
        
        case album
        case single
    }
}
