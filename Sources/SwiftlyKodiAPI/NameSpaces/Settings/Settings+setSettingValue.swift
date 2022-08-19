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
    public static func setSettingValue(setting: Setting.ID, value: Int) async {
        logger("Settings.SetSettingValue")
        let kodi: KodiConnector = .shared
        let request = SetSettingValue(setting: setting, value: value)
        do {
            let result = try await kodi.sendRequest(request: request)
            //return result.songdetails
        } catch {
            logger("Loading song details failed with error: \(error)")
            //return Audio.Details.Song()
        }
        
        //KodiConnector.shared.sendMessage(message: SetSettingValue(setting: setting, value: value))
    }
    
    /// Changes the value of a setting (Kodi API)
    struct SetSettingValue: KodiAPI {
        let method: Methods = .settingsSetSettingvalue
        
        /// Setting  ID
        let setting: Setting.ID
        /// Setting value
        let value: Int
        /// The JSON creator
        var parameters: Data {
            var params = Params()
            params.setting = setting.rawValue
            params.value = value
            return buildParams(params: params)
        }
        /// The request struct
        struct Params: Encodable {
            /// Setting ID
            var setting = ""
            /// Setting value
            var value = 0
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
        
