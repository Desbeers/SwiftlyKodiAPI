//
//  Application+Property+Value.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Application.Property {
    
    /// Values of the Application
    struct Value: Codable, Equatable {
        public var language: String = ""
        public var muted: Bool = false
        public var name: String = ""
        public var sorttokens: [String] = []
        public var version: Version = Version()
        public var volume: Double = 0
        
        /// The version struct (major and minor number)
        public struct Version: Codable, Equatable {
            /// Major version number
            public var major: Int = 0
            /// Minor version number
            public var minor: Int = 0
        }
    }
}
