//
//  Settings+setSettingValue.swift.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

// MARK:  setSettingValue

extension Settings {
    
    /// Changes the value of a setting (Kodi API)
    /// - Parameters:
    ///   - setting: The ``Setting/ID`` to set
    ///   - int: The optional Int value
    ///   - bool: The optional Bool value
    public static func setSettingValue(setting: Setting.ID, int: Int? = nil , bool: Bool? = nil) async {
        logger("Settings.SetSettingValue")
        let message = SetSettingValue(setting: setting, valueInt: int, valueBool: bool)
        KodiConnector.shared.sendMessage(message: message)
    }
    
    /// Changes the value of a setting (Kodi API)
    fileprivate struct SetSettingValue: KodiAPI {
        /// The method
        let method: Methods = .settingsSetSettingvalue
        /// Setting  ID
        let setting: Setting.ID
        /// Setting Int value
        let valueInt: Int?
        /// Setting Bool value
        let valueBool: Bool?
        /// The JSON creator
        var parameters: Data {
            if let valueInt = valueInt {
                return buildParams(params: ParamsInt(setting: setting.rawValue, value: valueInt))
            }
            if let valueBool = valueBool {
                return buildParams(params: ParamsBool(setting: setting.rawValue, value: valueBool))
            }
            return Data()
        }
        /// The request struct
        struct ParamsInt: Encodable {
            /// Setting ID
            var setting: String
            /// Setting value
            var value: Int
        }
        struct ParamsBool: Encodable {
            /// Setting ID
            var setting: String
            /// Setting value
            var value: Bool
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
