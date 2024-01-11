//
//  Settings+setSettingValue.swift.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

// MARK: setSettingValue

extension Settings {

    /// Changes the value of a setting (Kodi API)
    /// - Parameters:
    ///   - setting: The ``Setting/ID`` to set
    ///   - int: The optional Int value
    ///   - bool: The optional Bool value
    ///   - string: The optional String value
    ///   - list: The optional [Int] value
    public static func setSettingValue(
        setting: Setting.ID,
        int: Int? = nil,
        bool: Bool? = nil,
        string: String? = nil,
        list: [Int]? = nil
    ) async {
        let message = SetSettingValue(
            setting: setting,
            valueInt: int,
            valueBool: bool,
            valueString: string,
            valueList: list
        )
        KodiConnector.shared.sendMessage(message: message)
    }

    /// Changes the value of a setting (Kodi API)
    fileprivate struct SetSettingValue: KodiAPI {
        /// The method
        let method: Method = .settingsSetSettingvalue
        /// Setting  ID
        let setting: Setting.ID
        /// Setting Int value
        let valueInt: Int?
        /// Setting Bool value
        let valueBool: Bool?
        /// Setting String value
        let valueString: String?
        /// Setting List value
        let valueList: [Int]?
        /// The JSON creator
        var parameters: Data {
            if let valueInt {
                return buildParams(params: ParamsInt(setting: setting.rawValue, value: valueInt))
            }
            if let valueBool {
                return buildParams(params: ParamsBool(setting: setting.rawValue, value: valueBool))
            }
            if let valueString {
                return buildParams(params: ParamsString(setting: setting.rawValue, value: valueString))
            }
            if let valueList {
                return buildParams(params: ParamsList(setting: setting.rawValue, value: valueList))
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
        struct ParamsString: Encodable {
            /// Setting ID
            var setting: String
            /// Setting value
            var value: String
        }
        struct ParamsList: Encodable {
            /// Setting ID
            var setting: String
            /// Setting value
            var value: [Int]
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
