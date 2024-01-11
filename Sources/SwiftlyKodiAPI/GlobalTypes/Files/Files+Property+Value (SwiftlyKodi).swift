//
//  Files+Property+Value.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Files.Property {

    /// The property value of a file (SwiftlyKodi Type)
    struct Value: Codable {
        var details = Details()
        var mode: Mode = .redirect

        struct Details: Codable {
            var path: String = ""
        }

        enum Mode: String, Codable {
            case redirect
            case direct
        }
    }
}
