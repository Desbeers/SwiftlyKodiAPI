//
//  KodiSetting+Details+Setting.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

public extension Setting.Details {

    /// Setting details (SwiftlyKodi Type)
    struct KodiSetting: Identifiable, Equatable, Decodable, Sendable {
//        public static func == (lhs: Setting.Details.KodiSetting, rhs: Setting.Details.KodiSetting) -> Bool {
//            return lhs.settingInt?.value == rhs.settingInt?.value &&
//            lhs.settingBool?.value == rhs.settingBool?.value &&
//            lhs.enabled == rhs.enabled
//        }

        /// # Calculated variables

        public var id: Setting.ID {
            base.id
        }

        /// # Variables

        var enabled: Bool = true
        public var parent: Setting.ID = .none
        /// Kodi calls this `type` but that is a reserved word
        public var settingType: Setting.Details.SettingType = .unknown

        /// # Setting.Details.Base

        var base = Base()

        /// # Setting.Details.Control

        var control = Control()

        var settingBool: SettingBool?
        var settingInt: SettingInt?
        var settingList: SettingList?
        var settingString: SettingString?
        var settingAddon: SettingAddon?

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

            if base.id != .unknown {

                control = try Control(from: decoder)

                let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)
                self.enabled = try container.decode(Bool.self, forKey: .enabled)

                let parent = try container.decode(String.self, forKey: .parent)

                if let parent = Setting.ID(rawValue: parent) {
                    self.parent = parent
                }

                self.settingType = try container.decode(Setting.Details.SettingType.self, forKey: .settingType)

                switch settingType {
                case .bool:
                    self.settingBool = try SettingBool(from: decoder)
                case .int:
                    self.settingInt = try SettingInt(from: decoder)
                case .list:
                    self.settingList = try SettingList(from: decoder)
                case .string:
                    self.settingString = try SettingString(from: decoder)
                case .addon:
                    self.settingAddon = try SettingAddon(from: decoder)
                default:
                    break
                }
            }
        }
    }
}
