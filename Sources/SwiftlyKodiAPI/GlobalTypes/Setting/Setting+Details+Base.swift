//
//  Setting+Details+Base.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Setting.Details {
    
    /// Setting values
    struct Base: Identifiable, Equatable, Decodable {
        /// Make it equatable
        public static func == (lhs: Setting.Details.Base, rhs: Setting.Details.Base) -> Bool {
            return lhs.valueInt == rhs.valueInt && lhs.valueBool == rhs.valueBool && lhs.enabled == rhs.enabled
        }
        
        /// # Setting.Details.Base
        
        /// The ID of the setting
        public var id: Setting.ID = .unknown
        /// The label of the setting
        public var label: String = ""
        /// Optional help of the setting
        public var help: String = ""
        
        /// Optional Int value of the setting
        public var valueInt: Int = 0
        /// Optional Bool value of the setting
        public var valueBool: Bool = false
        /// Minimum limit of the setting
        public var minimum: Int = 0;
        /// Maximum limit of the setting
        public var maximum: Int = 15;
        /// Bool if the setting is enabled or not
        public var enabled: Bool = false
        /// The optional parent of the setting
        public var parent: Setting.ID = .unknown
        
        /// # Setting.Details.ControlBase
        
        /// Control Base
        public var control = Setting.Details.ControlBase()
        
        /// # Setting.Details.SettingInt
        
        /// Optional settings Int
        public var settingInt: [Setting.Details.SettingInt]?
        /// The coding keys
        enum CodingKeys: String, CodingKey {
            case settingID = "id"
            case control
            case options
            case label
            case help
            case value
            case maximum
            case minimum
            case definition
            case enabled
            case parent
        }
        /// The Coding Keys for a Definition
        enum Definition: String, CodingKey {
            case options
        }
    }
}

extension Setting.Details.Base {
    
    /// Custom decoder
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Setting.Details.Base.CodingKeys> = try decoder.container(keyedBy: Setting.Details.Base.CodingKeys.self)
        let settingID = try container.decode(String.self, forKey: Setting.Details.Base.CodingKeys.settingID)
        /// Only decode settings we know about
        if let kodioID = Setting.ID(rawValue: settingID) {
            self.id = kodioID
            
            /// ### Definition level

            if let definition = try? container.nestedContainer(keyedBy: Setting.Details.Base.Definition.self, forKey: .definition) {
                self.settingInt = try definition.decodeIfPresent([Setting.Details.SettingInt].self, forKey: Setting.Details.Base.Definition.options)
            } else {
                self.settingInt = try container.decodeIfPresent([Setting.Details.SettingInt].self, forKey: Setting.Details.Base.CodingKeys.options)
            }
            
            self.control = try container.decode(Setting.Details.ControlBase.self, forKey: Setting.Details.Base.CodingKeys.control)
            self.label = try container.decode(String.self, forKey: Setting.Details.Base.CodingKeys.label)
            self.help = try container.decodeIfPresent(String.self, forKey: Setting.Details.Base.CodingKeys.help) ?? ""
            
            let parent = try container.decode(String.self, forKey: Setting.Details.Base.CodingKeys.parent)
            
            if let parent = Setting.ID(rawValue: parent) {
                self.parent = parent
            }
            
            if let valueInt = try? container.decodeIfPresent(Int.self, forKey: Setting.Details.Base.CodingKeys.value) {
                self.valueInt = valueInt
            }
            
            if let valueBool = try? container.decodeIfPresent(Bool.self, forKey: Setting.Details.Base.CodingKeys.value) {
                self.valueBool = valueBool
            }
            
            self.enabled = try container.decode(Bool.self, forKey: Setting.Details.Base.CodingKeys.enabled)
            self.minimum = try container.decodeIfPresent(Int.self, forKey: Setting.Details.Base.CodingKeys.minimum) ?? 0
            self.maximum = try container.decodeIfPresent(Int.self, forKey: Setting.Details.Base.CodingKeys.maximum) ?? 0
        }
    }
}
