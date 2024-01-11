//
//  Audio+Album+ReleaseType.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//
import Foundation

public extension Audio.Album {

    /// The release type of an album (Global Kodi Type)
    enum ReleaseType: String, Codable, Sendable {
        /// The type is an album
        case album
        /// The type is a single
        case single
    }
}
