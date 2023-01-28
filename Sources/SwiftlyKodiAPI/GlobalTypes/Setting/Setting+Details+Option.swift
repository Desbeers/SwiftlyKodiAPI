//
//  Setting+Details+Option.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

public extension Setting.Details {

    /// Setting Option (SwiftlyKodi type)
    struct Option: Hashable, Decodable, Sendable {
        public var label: String
        public var value: Int

        enum CodingKeys: CodingKey {
            case label
            case value
        }
    }
}
