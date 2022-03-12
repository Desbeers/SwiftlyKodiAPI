//
//  File.swift
//  
//
//  Created by Nick Berendsen on 11/03/2022.
//

import Foundation

/// A struct for decoding Kodi notifications
///
/// Not all notice details are that interesting.
/// For example, a notification for `Player.OnPropertyChanged` will just give the changed property,
/// so that means that every property has to be checked for the one that is changed.
/// Better just get all the properties with `Player.GetProperties`.
///
/// Also, a library item can have it's ID on different placed in the JSON.
/// The decoder for this struct will check all placed and just put it in the 'root' of the struct.
public struct NotificationItem: Decodable {
    
    /// Top level
    var method: NotificationMethod = .unknown
    
    /// Params level
    var sender: String = "self"
    
    /// Item level
    var media: MediaType = .none
    var itemID: Int = 0
    
    /// The ID of the player
    /// - 1 = audio
    /// - 2 = movie
    /// - 3 = picture
    var playerID: Int = 0
    /// The speed of the player
    var playerSpeed: Int = 0
    
    var playlistID: Int = -1
    var playlistEnded: Bool = false
    
    /// ### Property level
    /// Partymode
    /// - Note: Kodi does not notify when you turn partymode on
    var partymode: Bool = false
    var shuffled: Bool = false
    var repeating: String = "off"
}


extension NotificationItem {
    
    /// # Top-level coding keys
    enum CodingKeys: String, CodingKey {
        case method
        case params
    }
    
    /// ## Params-level coding keys
    enum ParamsKeys: String, CodingKey {
        case sender
        case data
    }
    
    /// ### Data-level coding keys
    enum DataKeys: String, CodingKey {
        case item
        case player
        case property
        case playlistEnded = "end"
        case playlistID = "playlistid"
        /// - Note: When receiving an "OnUpdate" notice we get below values:
        case itemID = "id"
        case media = "type"
    }
    
    /// #### Item-level coding keys
    /// - Note: When receiving player notices
    enum ItemKeys: String, CodingKey {
        case itemID = "id"
        case media = "type"
    }
    
    /// ### Player-level coding keys
    enum PlayerKeys: String, CodingKey {
        case playerID = "playerid"
        case playerSpeed = "speed"
    }
    
    /// ### Property-level coding keys
    enum PropertyKeys: String, CodingKey {
        case partymode
        case shuffled
        /// Repeat is a reserved word
        case repeating = "repeat"
    }
}

extension NotificationItem {
    public init(from decoder: Decoder) throws {
        
        /// # Top level
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let rawValue = try container.decodeIfPresent(String.self, forKey: .method),
           let method = NotificationMethod(rawValue: rawValue) {
            self.method = method
        }

        /// ## Params level
        let params = try container.nestedContainer(keyedBy: ParamsKeys.self, forKey: .params)
        sender = try params.decodeIfPresent(String.self, forKey: .sender) ?? sender
        
        /// ### Data level
        let data = try params.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        itemID = try data.decodeIfPresent(Int.self, forKey: .itemID) ?? itemID
        playlistID = try data.decodeIfPresent(Int.self, forKey: .playlistID) ?? playlistID
        playlistEnded = try data.decodeIfPresent(Bool.self, forKey: .playlistEnded) ?? playlistEnded

        if let rawValue = try data.decodeIfPresent(String.self, forKey: .media),
           let media = MediaType(rawValue: rawValue) {
            self.media = media
        }
        
        /// ### Item level
        let item = try? data.nestedContainer(keyedBy: ItemKeys.self, forKey: .item)
        itemID = try item?.decodeIfPresent(Int.self, forKey: .itemID) ?? itemID

        if let rawValue = try item?.decodeIfPresent(String.self, forKey: .media),
           let media = MediaType(rawValue: rawValue) {
            self.media = media
        }
        
        /// ### Player level
        let player = try? data.nestedContainer(keyedBy: PlayerKeys.self, forKey: .player)
        playerID = try player?.decodeIfPresent(Int.self, forKey: .playerID) ?? playerID
        playerSpeed = try player?.decodeIfPresent(Int.self, forKey: .playerSpeed) ?? playerSpeed
        
        /// ### Property-level
        let property = try? data.nestedContainer(keyedBy: PropertyKeys.self, forKey: .property)
        partymode = try property?.decodeIfPresent(Bool.self, forKey: .partymode) ?? partymode
        shuffled = try property?.decodeIfPresent(Bool.self, forKey: .shuffled) ?? shuffled
        repeating = try property?.decodeIfPresent(String.self, forKey: .repeating) ?? repeating
    }
}

//extension KodiConnector {
//
//    /// The struct for a Kodi notification item
//    struct NotificationItem: Decodable {
//        /// The method
//        var method: String
//        /// The params
//        var params = Params()
//        /// The params struct
//        struct Params: Decodable {
//            /// The optional data from the notice
//            var data: DataItem?
//            /// The sender of the notice
//            var sender: String = ""
//        }
//        /// The struct for the notification data
//        struct DataItem: Decodable {
//            /// The item ID
//            var itemID: Int?
//            /// The type of item
//            var type: String?
//            /// Coding keys
//            enum CodingKeys: String, CodingKey {
//                /// The keys
//                case type
//                /// ID is a reserved word
//                case itemID = "id"
//            }
//        }
//    }
//    
//}
