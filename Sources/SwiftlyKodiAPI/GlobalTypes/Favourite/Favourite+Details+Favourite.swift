//
//  Favourite+Details+Favourite.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

public extension Favourite.Details {

    /// Favourite details
    struct Favourite: Decodable {
        var path: String?
        var title: String = ""
        var type: String = ""
        var window: String?
        var windowparameter: String?
    }
}
