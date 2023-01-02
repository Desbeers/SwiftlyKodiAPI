//
//  Media+Artwork.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

public extension Media {

    /// Ratings for a Media item
    /// - Note: This is a 'custom struct; Kodi defines this as an 'any'
    struct Ratings: Codable, Equatable, Hashable {
        public init(defaults: Media.Ratings.Defaults? = nil) {
            self.defaults = defaults
        }

        public var defaults: Defaults?

        enum CodingKeys: String, CodingKey {
            case defaults = "default"
        }

        public struct Defaults: Codable, Equatable, Hashable {
            public var defaults: Bool = false
            public var rating: Double = 0
            public var votes: Int = 0

            enum CodingKeys: String, CodingKey {
                case defaults = "default"
                case rating
                case votes
            }
        }
    }
}
