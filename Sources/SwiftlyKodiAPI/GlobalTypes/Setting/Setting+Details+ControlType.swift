//
//  Setting+Details+ControlType.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

public extension Setting.Details {

    /// Control Type (SwiftlyKodi type)
    enum ControlType: String, Decodable {
        case unknown
        case list
        case spinner
        case toggle
        case edit
        case slider
        case button
    }
}
