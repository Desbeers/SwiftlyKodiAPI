//
//  List+Limits.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension List {
    /// The limits fields for JSON requests
    public struct Limits: Codable {
        /// The end of the limits
        var end: Int = -1
        /// The order
        var start: Int = 0
    }
}
