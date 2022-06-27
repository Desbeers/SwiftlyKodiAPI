//
//  Player+setRepeat.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Player {
    
    /// Toggle the repeat mode of the the current player
    static func setRepeat() {
        /// Struct for SetRepeat
        struct SetRepeat: KodiAPI {
            let method: KodiConnector.Method = .playerSetRepeat
            /// The JSON creator
            var parameters: Data {
                /// Struct for SetRepeat
                struct Parameters: Encodable {
                    /// The player ID
                    let playerid = 0
                    /// Cycle trough repeating modus
                    let repeating = "cycle"
                    /// Coding keys
                    /// - Note: Repeat is a reserved word
                    enum CodingKeys: String, CodingKey {
                        /// The key
                        case playerid
                        /// Repeat is a reserved word
                        case repeating = "repeat"
                    }
                }
                return buildParams(params: Parameters())
            }
            /// The response struct
            struct Response: Decodable { }
        }
        KodiConnector.shared.sendMessage(message: SetRepeat())
    }
}
