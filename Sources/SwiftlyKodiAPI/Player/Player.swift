//
//  File.swift
//  
//
//  Created by Nick Berendsen on 25/06/2022.
//

import Foundation

/// A Struct with all Player related items
public struct Player {
    /// Just a placeholder
}

extension Player {
    
    /// The properties of the Player
    public struct Property {
        /// The names of the properties we ask from Kodi
        static let name = ["audiostreams",
                 "cachepercentage",
                 "canchangespeed",
                 "canmove",
                 "canrepeat",
                 "canrotate",
                 "canseek",
                 "canshuffle",
                 "canzoom",
                 "currentaudiostream",
                 "currentsubtitle",
                 "currentvideostream",
                 "live",
                 "partymode",
                 "percentage",
                 "playlistid",
                 "position",
                 "repeat",
                 "shuffled",
                 "speed",
                 "subtitleenabled",
                 "time",
                 "totaltime",
                 "type"]
        /// The property values of the player
        public struct Value: Decodable {
            public var audioStreams: [Player.Audio.Stream] = []
            public var cachePercentage: Double = 0.0
            public var canChangeSpeed: Bool = false
            public var canMove: Bool = true
            public var canRepeat: Bool = true
            public var canRotate: Bool = false
            public var canSeek: Bool = false
            public var canShuffle: Bool = false
            public var canZoom: Bool = false
            public var currentAudioStream = Player.Audio.Stream()
            public var currentSubtitle = Player.Subtitle()
            public var currentVideoStream = Player.Video.Stream()
            public var live: Bool = false
            public var partymode: Bool = false
            public var percentage: Double = 0.0
            public var playlistID: Int = -1
            public var playlistPosition: Int = -1
            public var repeating: Player.Repeat = .off
            public var shuffled: Bool = false
            public var speed: Int = 0
            public var subtitleEnabled: Bool = false
            public var time = Player.Position.Time()
            public var timeTotal = Player.Position.Time()
            public var type: Player.MediaType = .video
            /// The Codings Keys
            public enum CodingKeys: String, CodingKey {
                case audioStreams = "audiostreams"
                case cachePercentage = "cachepercentage"
                case canChangeSpeed = "canchangespeed"
                case canMove = "canmove"
                case canRepeat = "canrepeat"
                case canRotate = "canrotate"
                case canSeek = "canseek"
                case canShuffle = "canshuffle"
                case canZoom = "canzoom"
                case currentAudioStream = "currentaudiostream"
                case currentSubtitle = "currentsubtitle"
                case currentVideoStream = "currentvideostream"
                case live
                case partymode
                case percentage
                case playlistID = "playlistid"
                case playlistPosition = "position"
                case repeating = "repeat"
                case shuffled
                case speed
                case subtitleEnabled = "subtitleenabled"
                case time
                case timeTotal = "totaltime"
                case type
            }
        }
    }
    
    /// Position details of the player
    public struct Position {
        /// The time details of the player
        public struct Time: Decodable {
            public var hours: Int = 0
            public var milliseconds: Int = 0
            public var minutes: Int = 0
            public var seconds: Int = 0
        }
    }
    
    /// Audio details of the player
    public struct Audio {
        /// Audio stream details of the player
        public struct Stream: Decodable {
            public var bitrate: Int = 0
            public var channels: Int = 0
            public var codec: String = ""
            public var index: Int = 0
            public var isDefault: Bool = false
            public var isImpaired: Bool = false
            public var isOriginal: Bool = false
            public var language: String = ""
            public var name: String = ""
            public var samplerate: Int = 0
            enum CodingKeys: String, CodingKey {
                case bitrate, channels, codec, index
                case isDefault = "isdefault"
                case isImpaired = "isimpaired"
                case isOriginal = "isoriginal"
                case language, name, samplerate
            }
        }
    }
    
    public enum ID: Int, Decodable {
        /// The audio player
        case audio = 0
        /// The video player
        case video = 1
        /// The picture player
        case picture = 2
    }
    
    public enum Repeat: String, Decodable {
        case off = "off"
        case one = "one"
        case all = "all"
    }
    
    /// - Note: Kodi calls this 'type' but that is reserved word
    public enum MediaType: String, Decodable {
        /// The audio player
        case audio
        /// The video player
        case video
        /// The picture player
        case picture
    }
    
    public struct Subtitle: Decodable {
        public var index: Int = 0
        public var isDefault: Bool = false
        public var isForced: Bool = false
        public var isImpaired: Bool = false
        public var language: String = ""
        public var name: String = ""
        enum CodingKeys: String, CodingKey {
            case index
            case isDefault = "isdefault"
            case isForced = "isforced"
            case isImpaired = "isimpaired"
            case language, name
        }
    }
    
    public struct Video {
        public struct Stream: Decodable {
            public var codec: String = ""
            public var height: Int = 0
            public var index: Int = 0
            public var language: String = ""
            public var name: String = ""
            public var width: Int = 0
        }
    }
}

extension Player.Property.Value {
    /// Custom init for the Player properties because some values will be changed to enums
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        audioStreams = try container.decode([Player.Audio.Stream].self, forKey: .audioStreams)
        cachePercentage = try container.decode(Double.self, forKey: .cachePercentage)
        canChangeSpeed = try container.decode(Bool.self, forKey: .canChangeSpeed)
        canMove = try container.decode(Bool.self, forKey: .canMove)
        canRepeat = try container.decode(Bool.self, forKey: .canRepeat)
        canRotate = try container.decode(Bool.self, forKey: .canRotate)
        canSeek = try container.decode(Bool.self, forKey: .canSeek)
        canShuffle = try container.decode(Bool.self, forKey: .canShuffle)
        canZoom = try container.decode(Bool.self, forKey: .canZoom)
        currentAudioStream = try container.decode(Player.Audio.Stream.self, forKey: .currentAudioStream)
        /// - Note: 'currentSubtitle' is optional; only video has it
        currentSubtitle = try container.decodeIfPresent(Player.Subtitle.self, forKey: .currentSubtitle) ?? currentSubtitle
        /// - Note: 'currentSubtitle' is optional; only video has it
        currentVideoStream = try container.decodeIfPresent(Player.Video.Stream.self, forKey: .currentVideoStream) ?? currentVideoStream
        live = try container.decode(Bool.self, forKey: .live)
        partymode = try container.decode(Bool.self, forKey: .partymode)
        percentage = try container.decode(Double.self, forKey: .percentage)
        playlistID = try container.decode(Int.self, forKey: .playlistID)
        playlistPosition = try container.decode(Int.self, forKey: .playlistPosition)
        if let rawValue = try container.decodeIfPresent(String.self, forKey: .repeating),
           let method = Player.Repeat(rawValue: rawValue) {
            self.repeating = method
        }
        shuffled = try container.decode(Bool.self, forKey: .shuffled)
        speed = try container.decode(Int.self, forKey: .speed)
        subtitleEnabled = try container.decode(Bool.self, forKey: .subtitleEnabled)
        time = try container.decode(Player.Position.Time.self, forKey: .time)
        timeTotal = try container.decode(Player.Position.Time.self, forKey: .timeTotal)
        if let rawValue = try container.decodeIfPresent(String.self, forKey: .type),
           let media = Player.MediaType(rawValue: rawValue) {
            self.type = media
        }
    }
}
