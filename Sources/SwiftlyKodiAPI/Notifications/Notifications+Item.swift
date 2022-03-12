//
//  File.swift
//  
//
//  Created by Nick Berendsen on 11/03/2022.
//

import Foundation

struct NotificationItemModel: Decodable {
    
    /// Top level
    var method: NotificationMethod = .unknown
    
    /// Params level
    var sender: String = "self"
    
    /// Item level
    var media: MediaType = .none
    var itemID: Int = 0
    
    /// Player level
    var playerID: Int = 0
    var playerSpeed: Int = 0
    
    /// ### Property level
    /// Partymode
    /// - Note: Kodi does not notify when you turn partymode on
    var partymode: Bool = false
    var shuffled: Bool = false
    var repeating: String = "off"
}


extension NotificationItemModel {
    
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

extension NotificationItemModel {
    init(from decoder: Decoder) throws {
        
        /// # Top level
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let rawValue = try container.decodeIfPresent(String.self, forKey: .method),
           let method = NotificationMethod(rawValue: rawValue) {
            self.method = method
        } else {
            print("Unknown method: \(try container.decodeIfPresent(String.self, forKey: .method) )")
            self.method = .unknown
        }

        /// ## Params level
        let params = try container.nestedContainer(keyedBy: ParamsKeys.self, forKey: .params)
        sender = try params.decodeIfPresent(String.self, forKey: .sender) ?? sender
        
        /// ### Data level
        let data = try params.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        itemID = try data.decodeIfPresent(Int.self, forKey: .itemID) ?? itemID

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

extension KodiConnector {
    
    struct NotificationData: Decodable {
        /// The media item ID (called `id` by Kodi)
        var itemID: Int
        /// The type of media item (called `type` by Kodi)
        var media: MediaType
        
        /// # Playlist data
        
        /// The playlist ID
        var playlistID: Int
        /// Position in the playlist (called `position` by Kodi
        var playlistPosition: Int = -1
        
        /// # Coding keys
        
        /// Coding keys
        enum CodingKeys: String, CodingKey {
            /// ID is a reserved word
            case itemID = "id"
            /// The type of media
            case media = "type"
            /// lowerCamelCase
            case playlistID = "playlistid"
            /// Give it a more describable name
            case playlistPosition = "position"
        }
        
        /// # Custom decoder
        
        
        
    }

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
