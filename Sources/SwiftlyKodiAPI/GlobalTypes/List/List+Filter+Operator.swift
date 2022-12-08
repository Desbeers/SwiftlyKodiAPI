//
//  List+Filter+Operator.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension List.Filter {

    /// The operator on a filter (Globall Kody Type)
    enum Operator: String, Codable {
        case contains
        case doesNotContain = "doesnotcontain"
        // case is
        case isNot = "isnot"
        case startsWith = "startswith"
        case endsWith = "endswith"
        case greaterThan = "greaterthan"
        case lessThan = "lessthan"
        case after
        case before
        case inTheLast = "inthelast"
        case notInTheLast = "notinthelast"
        // case true
        // case false
        case between
    }

}
