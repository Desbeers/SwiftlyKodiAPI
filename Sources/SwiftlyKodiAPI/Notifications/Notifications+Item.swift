//
//  File.swift
//  
//
//  Created by Nick Berendsen on 11/03/2022.
//

import Foundation

extension KodiConnector {

    /// The struct for a Kodi notification item
    struct NotificationItem: Decodable {
        /// The method
        var method: String
        /// The params
        var params = Params()
        /// The params struct
        struct Params: Decodable {
            /// The optional data from the notice
            var data: DataItem?
            /// The sender of the notice
            var sender: String = ""
        }
        /// The struct for the notification data
        struct DataItem: Decodable {
            /// The item ID
            var itemID: Int?
            /// The type of item
            var type: String?
            /// Coding keys
            enum CodingKeys: String, CodingKey {
                /// The keys
                case type
                /// ID is a reserved word
                case itemID = "id"
            }
        }
    }
    
}
