//
//  List+Filter+Field.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

extension List.Filter {

    /// The field on a filter (SwiftlyKodi Type)
    enum Field: String, Codable {
        case dateModified = "datemodified"
    }
}
