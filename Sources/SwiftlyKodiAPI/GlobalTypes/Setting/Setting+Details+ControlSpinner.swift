//
//  Setting+Details+ControlSpinner.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Setting.Details {
    
    /// Control Base details
    struct ControlSpinner: Decodable {
        public var delayed: Bool = false
        public var format: String = ""
        public var type: String = ""
        
        enum CodingKeys: CodingKey {
            case delayed
            case format
            case type
        }
        
    }
}
