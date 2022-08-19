//
//  Setting+Details+Base.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Setting.Details {
    
    /// Setting values
    struct Base: Identifiable, Decodable {
        
        /// # Setting.Details.Base
        
        /// The ID of the setting
        public var id: Setting.ID = .unknown
        /// The label of the setting
        public var label: String = ""
        /// Optional help of the setting
        public var help: String?
        
        /// Optional value of the setting
        public var value: Int = 0
        
        public var maximum: Int = 15;
        public var minimum: Int = 0;
        
        /// # Setting.Details.ControlBase
        
        public var control = Setting.Details.ControlBase()
        
        /// # Setting.Details.SettingInt
        
        public var settingInt: [Setting.Details.SettingInt]?
        
        enum CodingKeys: String, CodingKey {
            //case id
            
            case settingID = "id"
            case control
            case options
            case label
            case help
            case value
            case maximum
            case minimum
            case definition
        }
        
        enum Definition: String, CodingKey {
            case options
        }
    }
}

extension Setting.Details.Base {
    
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Setting.Details.Base.CodingKeys> = try decoder.container(keyedBy: Setting.Details.Base.CodingKeys.self)
        
        //self.id = try container.decode(Setting.ID.self, forKey: Setting.Details.Base.CodingKeys.id)
        
        let settingID = try container.decode(String.self, forKey: Setting.Details.Base.CodingKeys.settingID)
        
//        if let definition = try? container.nestedContainer(keyedBy: Definition.self, forKey: .definition) {
//            dump(try definition.decodeIfPresent([Setting.Details.SettingInt].self, forKey: Definition.options))
//        }

        
        if let kodioID = Setting.ID(rawValue: settingID) {
            self.id = kodioID
            print(kodioID)
            
            if let definition = try? container.nestedContainer(keyedBy: Definition.self, forKey: .definition) {
                dump(try definition.decodeIfPresent([Setting.Details.SettingInt].self, forKey: Definition.options))
            }
            
            //let definition = try? container.nestedContainer(keyedBy: Definition.self, forKey: .definition)
            
            //dump(definition)
            
            /// ### Definition level
            if let definition = try? container.nestedContainer(keyedBy: Setting.Details.Base.Definition.self, forKey: .definition) {
                //print("HAVE DEFINITION!!")
                self.settingInt = try definition.decodeIfPresent([Setting.Details.SettingInt].self, forKey: Setting.Details.Base.Definition.options)
            } else {
                //print("NO DEFINITION....")
                self.settingInt = try container.decodeIfPresent([Setting.Details.SettingInt].self, forKey: Setting.Details.Base.CodingKeys.options)
            }
            
            self.control = try container.decode(Setting.Details.ControlBase.self, forKey: Setting.Details.Base.CodingKeys.control)
            //self.settingInt = try container.decodeIfPresent([Setting.Details.SettingInt].self, forKey: Setting.Details.Base.CodingKeys.options)
            self.label = try container.decode(String.self, forKey: Setting.Details.Base.CodingKeys.label)
            self.help = try container.decodeIfPresent(String.self, forKey: Setting.Details.Base.CodingKeys.help)
            self.value = try container.decodeIfPresent(Int.self, forKey: Setting.Details.Base.CodingKeys.value) ?? 0
            self.minimum = try container.decodeIfPresent(Int.self, forKey: Setting.Details.Base.CodingKeys.minimum) ?? 0
            self.maximum = try container.decodeIfPresent(Int.self, forKey: Setting.Details.Base.CodingKeys.maximum) ?? 0
        }
        
    }
}
