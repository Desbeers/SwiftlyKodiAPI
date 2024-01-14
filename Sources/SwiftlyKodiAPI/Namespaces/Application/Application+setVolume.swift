//
//  Application+setVolume.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation
import OSLog

extension Application {

    /// Set the current volume (Kodi API)
    /// - Parameter volume: The new value for the volume
    public static func setVolume(host: HostItem, volume: Double) async {
        JSON.sendMessage(message: SetVolume(host: host, volume: volume))
    }

    /// Set the current volume (Kodi API)
    private struct SetVolume: KodiAPI {
        /// The host
        let host: HostItem
        /// The method
        let method = Method.applicationSetVolume
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(volume: Int(volume)))
        }
        /// The volume
        let volume: Double
        /// The parameters struct
        struct Params: Encodable {
            /// Volume
            let volume: Int
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
