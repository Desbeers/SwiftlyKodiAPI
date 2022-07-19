//
//  Notifications+Item.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Notifications {
    
    /// Notification item {Global Kodi Type)
    ///
    /// Not all notice details are that interesting.
    /// For example, a notification for `Player.OnPropertyChanged` will just give the changed property,
    /// so that means that every property has to be checked for the one that is changed.
    /// Better just get all the properties with `Player.GetProperties`.
    ///
    /// Also, a library item can have it's ID on different placed in the JSON.
    /// The decoder for this struct will check all placed and just put it in the 'root' of the struct.
    struct Item: Decodable, Equatable {
        
        /// Top level
        public var method: Method = .unknown
        
        /// Params level
        var sender: String = "self"
        
        /// Item level
        var media: Library.Media = .none
        var itemID: Int = 0
        
        /// The ID of the player
        /// - 1 = audio
        /// - 2 = video
        /// - 3 = picture
        var playerID: Player.ID = .audio
        /// The speed of the player
        var playerSpeed: Int = 0
        
        var playlistID: Int = -1
        var playlistEnded: Bool = false
        
        /// ### Property level
        /// Partymode
        /// - Note: Kodi does not notify when you turn partymode on
        var partymode: Bool = false
        var shuffled: Bool = false
        var repeating: Player.Repeat = .off
    }
}

extension Notifications.Item {
    
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

extension Notifications.Item {
    public init(from decoder: Decoder) throws {
        
        /// # Top level
        let container = try decoder.container(keyedBy: CodingKeys.self)
        /// - Note: 'method' is a String but we convert it to an Enum
        method = try container.decodeIfPresent(Notifications.Method.self, forKey: .method) ?? method
        
        /// ## Params level
        let params = try container.nestedContainer(keyedBy: ParamsKeys.self, forKey: .params)
        sender = try params.decodeIfPresent(String.self, forKey: .sender) ?? sender
        
        /// ### Data level
        let data = try? params.nestedContainer(keyedBy: DataKeys.self, forKey: .data)
        itemID = try data?.decodeIfPresent(Int.self, forKey: .itemID) ?? itemID
        playlistID = try data?.decodeIfPresent(Int.self, forKey: .playlistID) ?? playlistID
        playlistEnded = try data?.decodeIfPresent(Bool.self, forKey: .playlistEnded) ?? playlistEnded
        /// - Note: 'media' is a String but we convert it to an Enum
        media = try data?.decodeIfPresent(Library.Media.self, forKey: .media) ?? media
        
        /// ### Item level
        let item = try? data?.nestedContainer(keyedBy: ItemKeys.self, forKey: .item)
        itemID = try item?.decodeIfPresent(Int.self, forKey: .itemID) ?? itemID
        /// - Note: 'media' is a String but we convert it to an Enum
        media = try item?.decodeIfPresent(Library.Media.self, forKey: .media) ?? media
        
        /// ### Player level
        let player = try? data?.nestedContainer(keyedBy: PlayerKeys.self, forKey: .player)
        /// - Note: 'playerID' is an Int but we convert it to an Enum
        playerID = try player?.decodeIfPresent(Player.ID.self, forKey: .playerID) ?? playerID
        playerSpeed = try player?.decodeIfPresent(Int.self, forKey: .playerSpeed) ?? playerSpeed
        
        /// ### Property-level
        let property = try? data?.nestedContainer(keyedBy: PropertyKeys.self, forKey: .property)
        partymode = try property?.decodeIfPresent(Bool.self, forKey: .partymode) ?? partymode
        shuffled = try property?.decodeIfPresent(Bool.self, forKey: .shuffled) ?? shuffled
        /// - Note: 'repeating' is a String but we convert it to an Enum
        repeating = try property?.decodeIfPresent(Player.Repeat.self, forKey: .repeating) ?? repeating
    }
}
