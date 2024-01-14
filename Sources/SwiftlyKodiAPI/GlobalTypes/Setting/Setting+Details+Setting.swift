//
//  Setting+Details+Setting.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Setting.Details {

    /// Setting details (Global Kodi Type)
    struct Setting: Identifiable, Equatable, Decodable, Sendable {

        /// # Calculated variables

        /// The ID of the setting
        public var id: SwiftlyKodiAPI.Setting.ID {
            base.id
        }

        /// # Variables

        var enabled: Bool = true
        public var parent: SwiftlyKodiAPI.Setting.ID = .none
        /// Kodi calls this `type` but that is a reserved word
        public var settingType: SwiftlyKodiAPI.Setting.SettingType = .unknown

        /// # Setting.Details.Base

        var base = Base()

        /// # Setting.Details.Control

        var control = Control()

        public var boolean = SettingBool()
        public var integer = SettingInt()
        public var list = SettingList()
        public var string = SettingString()
        public var addon = SettingAddon()

        /// # Coding keys

        enum CodingKeys: String, CodingKey {

            case enabled
            case parent
            case settingType = "type"

            /// The base values
            case base

            /// The container containing the control
            case control
        }

        /// # Custom decoder

        public init(from decoder: Decoder) throws {

            base = try Base(from: decoder)

            /// Only decode settings we know about

            if base.id != SwiftlyKodiAPI.Setting.ID.unknown {

                control = try Control(from: decoder)

                let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
                self.enabled = try container.decode(Bool.self, forKey: .enabled)

                let parent = try container.decode(String.self, forKey: .parent)

                if let parent = Setting.ID(rawValue: parent) {
                    self.parent = parent
                }

                self.settingType = try container.decode(SwiftlyKodiAPI.Setting.SettingType.self, forKey: .settingType)

                switch settingType {
                case .boolean:
                    self.boolean = try SettingBool(from: decoder)
                case .integer:
                    self.integer = try SettingInt(from: decoder)
                case .list:
                    self.list = try SettingList(from: decoder)
                case .string:
                    self.string = try SettingString(from: decoder)
                case .addon:
                    self.addon = try SettingAddon(from: decoder)
                default:
                    break
                }
            }
        }
    }
}
