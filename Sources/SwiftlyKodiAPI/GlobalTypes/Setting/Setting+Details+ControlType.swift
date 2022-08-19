//
//  Setting+Details+ControlSpinner.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Setting.Details {
    
    /// Control Type (SwiftlyKodi type)
    enum ControlType: String, Decodable {
        case unknown
        case list
        case spinner
        case toggle
    }
}
