//
//  File.swift
//  
//
//  Created by Nick Berendsen on 06/05/2022.
//

import Foundation

/// A struct for an actor that is part of the cast in a movie or TV episode
public struct ActorItem: Codable, Identifiable, Hashable {
    /// Make it identifiable
    public var id = UUID()
    /// The name of the actor
    public var name: String = ""
    /// The order in the cast list
    public var order: Int = 0
    /// The role of the actor
    public var role: String = ""
    /// The optional thumbnail of the actor
    public var thumbnail: String? = ""
    
    
    public var icon: String {
        return getFilePath(file: thumbnail ?? "", type: .art)
    }
    /// Coding keys
    enum CodingKeys: String, CodingKey {
        /// The keys for this Actor Item
        case name, order, role, thumbnail
    }
}

//extension ActorItem {
//    /// In an extension so we can still use the memberwise initializer.
//    public init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        name = try container.decodeIfPresent(String.self, forKey: .name) ?? ""
//        order = try container.decodeIfPresent(Int.self, forKey: .order) ?? 0
//        role = try container.decodeIfPresent(String.self, forKey: .role) ?? ""
//        thumbnail = try getFilePath(file: container.decodeIfPresent(String.self, forKey: .thumbnail) ?? "", type: .art) ?? ""
//    }
//}

/// A struct for the streaming details for a media item
public struct StreamDetails: Codable, Identifiable, Hashable {
    /// Make it identifiable
    public var id = UUID()
    public var audio: [Audio] = []
    public var subtitle: [Subtitle] = []
    public var video: [Video] = []
    enum CodingKeys: String, CodingKey {
        case audio, subtitle, video
    }
    /// The audio details
    public struct Audio: Codable, Identifiable, Hashable {
        /// Make it identifiable
        public var id = UUID()
        public var channels: Int = 0
        public var codec: String = ""
        public var language: String = ""
        enum CodingKeys: String, CodingKey {
            case channels, codec, language
        }
    }
    /// The subtitles details
    public struct Subtitle: Codable, Identifiable, Hashable {
        /// Make it identifiable
        public var id = UUID()
        public var language: String = ""
        enum CodingKeys: String, CodingKey {
            case language
        }
    }
    /// The video details
    public struct Video: Codable, Identifiable, Hashable {
        /// Make it identifiable
        public var id = UUID()
        public var aspect: Double = 0
        public var codec: String = ""
        public var duration: Int = 0
        public var height: Int = 0
        public var language: String = ""
        public var stereomode: String = ""
        public var width: Int = 0
        enum CodingKeys: String, CodingKey {
            case aspect, codec, duration, height, language, stereomode, width
        }
    }

}
