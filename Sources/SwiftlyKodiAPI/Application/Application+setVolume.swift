//
//  Application+setVolume.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Application {
    
    /// Set the current volume
    /// - Parameter volume: The new volume
    public static func setVolume(volume: Double) async  {
        KodiConnector.shared.sendMessage(message: SetVolume(volume: volume))
    }
    
    /// Set the current volume (Kodi API)
    fileprivate struct SetVolume: KodiAPI {
        /// Method
        let method = Methods.applicationSetVolume
        /// The volume
        let volume: Double
        /// The JSON creator
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
