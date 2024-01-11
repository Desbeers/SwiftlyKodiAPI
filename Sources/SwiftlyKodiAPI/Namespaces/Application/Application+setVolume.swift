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
    public static func setVolume(volume: Double) async {
        KodiConnector.shared.sendMessage(message: SetVolume(volume: volume))
    }

    /// Set the current volume (Kodi API)
    fileprivate struct SetVolume: KodiAPI {
        /// The method
        let method = Method.applicationSetVolume
        /// The volume
        let volume: Double
        /// The parameters
        var parameters: Data {
            buildParams(params: Params(volume: Int(volume)))
        }
        /// The parameters struct
        struct Params: Encodable {
            /// Volume
            let volume: Int
        }
        /// The response struct
        struct Response: Decodable { }
    }
}
