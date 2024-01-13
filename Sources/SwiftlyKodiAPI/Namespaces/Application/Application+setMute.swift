//
//  Application+setMute.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

extension Application {

    /// Toggle mute/unmute (Kodi API)
    public static func setMute(host: HostItem) async {
        JSON.sendMessage(message: SetMute(host: host))
    }

    /// Toggle mute/unmute (Kodi API)
    fileprivate struct SetMute: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method = Method.applicationSetMute
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
