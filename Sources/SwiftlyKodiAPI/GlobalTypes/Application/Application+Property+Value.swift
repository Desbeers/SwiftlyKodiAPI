//
//  Application+Property+Value.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Application.Property {
    
    /// Values of the application properties (Global Kodi Type)
    struct Value: Codable, Equatable {
        /// The language of the application
        public var language: String = ""
        /// Bool if the volume of the application is muted or not
        public var muted: Bool = false
        /// The name of the application
        public var name: String = ""
        /// Articles ignored during sorting when ignorearticle is enabled
        public var sorttokens: [String] = []
        /// The version of the application
        public var version: Version = Version()
        /// The volume setting of the application
        public var volume: Double = 0
        /// The version of the application (major and minor number)
        public struct Version: Codable, Equatable {
            /// Major version number
            public var major: Int = 0
            /// Minor version number
            public var minor: Int = 0
        }
    }
}
