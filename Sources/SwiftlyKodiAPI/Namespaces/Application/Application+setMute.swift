//
//  Application+setMute.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Application {

    /// Toggle mute/unmute (Kodi API)
    public static func setMute() async {
        KodiConnector.shared.sendMessage(message: SetMute())
    }

    /// Toggle mute/unmute (Kodi API)
    fileprivate struct SetMute: KodiAPI {
        /// The method
        let method = Methods.applicationSetMute
        /// The parameters
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
