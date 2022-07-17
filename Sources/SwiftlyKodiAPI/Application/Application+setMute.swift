//
//  Application+setMute.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Application {
    
    /// Toggle mute/unmute
    public static func setMute() async  {
        KodiConnector.shared.sendMessage(message: SetMute())
    }
    
    /// Toggle mute/unmute (Kodi API)
    fileprivate struct SetMute: KodiAPI {
        /// Method
        let method = Methods.applicationSetMute
        /// The JSON creator
        var parameters: Data {
            buildParams(params: Params())
        }
        /// The parameters struct
        struct Params: Encodable {
            /// Toggle the mute
            let mute = "toggle"
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
