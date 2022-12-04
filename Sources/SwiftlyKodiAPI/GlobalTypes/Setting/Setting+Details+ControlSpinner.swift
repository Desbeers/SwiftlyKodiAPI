//
//  Setting+Details+ControlSpinner.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Setting.Details {
    
    /// Control Spinner details
    struct ControlSpinner: Decodable {
        
        /// # Setting.Details.ControlBase
        
        public var delayed: Bool = false
        public var format: String = ""
        public var type: String = ""
        
        /// # Coding keys
        
        enum CodingKeys: CodingKey {
            case delayed
            case format
            case type
        }
        
    }
}
