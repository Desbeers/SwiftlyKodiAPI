//
//  Audio+Album+ReleaseType.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//
import Foundation

public extension Audio.Album {

    /// The release type of an album
    enum ReleaseType: String, Codable {
        case album
        case single
    }
}
