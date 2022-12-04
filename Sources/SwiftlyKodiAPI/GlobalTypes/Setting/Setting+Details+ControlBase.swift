//
//  Setting+Details+ControlBase.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Setting.Details {
    
    /// Control Base details
    struct ControlBase: Decodable {
        
        /// # Setting.Details.ControlBase
        
        public var delayed: Bool = false
        public var format: String = ""
        /// Kodi calls this `type` but that is a reserved word
        public var widget: Setting.Details.ControlType = .list
        
        /// # Setting.Details.ControlRange
        
        public var formatLabel: String = ""
        public var minimumLabel: String = ""
        
        /// # Coding keys
        
        enum CodingKeys: String, CodingKey {
            case delayed
            case format
            case formatLabel = "formatlabel"
            case minimumLabel = "minimumlabel"
            case widget = "type"
        }
    }
}

extension Setting.Details.ControlBase {
    
    /// Custom decoder
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Setting.Details.ControlBase.CodingKeys> = try decoder.container(keyedBy: Setting.Details.ControlBase.CodingKeys.self)
        
        self.delayed = try container.decode(Bool.self, forKey: Setting.Details.ControlBase.CodingKeys.delayed)
        self.format = try container.decode(String.self, forKey: Setting.Details.ControlBase.CodingKeys.format)
        self.formatLabel = try container.decodeIfPresent(String.self, forKey: Setting.Details.ControlBase.CodingKeys.formatLabel) ?? "{0:d} sec"
        self.minimumLabel = try container.decodeIfPresent(String.self, forKey: Setting.Details.ControlBase.CodingKeys.minimumLabel) ?? "Off"
        self.widget = try container.decode(Setting.Details.ControlType.self, forKey: Setting.Details.ControlBase.CodingKeys.widget)
        
    }
}
