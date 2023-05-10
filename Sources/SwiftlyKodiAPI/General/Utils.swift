//
//  Utils.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

/// Utility functions (SwiftlyKodi Type)
enum Utils {
    // Just a namespace
}

extension Utils {

}

extension String {

    /// Make a string lowercase and without funny accents
    /// - Returns: A simplified String
    func simplify() -> String {
        folding(options: [.caseInsensitive, .diacriticInsensitive], locale: .current)
    }

}
