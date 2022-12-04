//
//  List+Limits.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension List {

    /// The limits fields for JSON requests (SwiftlyKodi Type)
    public struct Limits: Codable {
        /// Init the limits
        public init(end: Int = -1, start: Int = 0) {
            self.end = end
            self.start = start
        }
        /// The end of the limit
        public var end: Int
        /// The start of the limit
        public var start: Int
    }
}
