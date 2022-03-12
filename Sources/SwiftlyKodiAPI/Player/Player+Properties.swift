//
//  Player+Properties.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {
    
    /// Get the properties of the player
    func getPlayerProperties(playerID: Int) async {
        let request = PlayerGetProperties(playerID: playerID)
        do {
            let result = try await sendRequest(request: request)
            dump(result)
        } catch {
            print("Loading player properties failed with error: \(error)")
        }
    }
    
    /// Retrieves the values of the given properties (Kodi API)
    struct PlayerGetProperties: KodiAPI {
        /// The ID of the player
        let playerID: Int
        /// Method
        let method = Method.playerGetProperties
        /// The JSON creator
        var parameters: Data {
            var params = Params()
            params.playerid = playerID
            return buildParams(params: params)
        }
        /// The parameters struct
        struct Params: Encodable {
            /// The player ID
            var playerid = 0
            /// The properties we ask for
            let properties = ["audiostreams",
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
        }
        /// The response struct
        typealias Response = PlayerProperties
    }
}

/// A struct with the properties of the player
public struct PlayerProperties: Decodable {
    public var audioStreams: [PlayerAudioStream] = []
    public var cachePercentage: Double = 0.0
    public var canChangeSpeed: Bool = false
    public var canMove: Bool = true
    public var canRepeat: Bool = true
    public var canRotate: Bool = false
    public var canSeek: Bool = false
    public var canShuffle: Bool = false
    public var canZoom: Bool = false
    public var currentAudioStream = PlayerAudioStream()
    public var currentSubtitle = PlayerSubtitle()
    public var currentVideoStream = PlayerVideoStream()
    public var live: Bool = false
    public var partymode: Bool = false
    public var percentage: Double = 0.0
    public var playlistID: Int = -1
    public var playlistPosition: Int = -1
    public var repeating: PlayerRepeatMode = .off
    public var shuffled: Bool = false
    public var speed: Int = 0
    public var subtitleEnabled: Bool = false
    public var time = PlayerTime()
    public var timeTotal = PlayerTime()
    public var media: PlayerType = .video
}

public extension PlayerProperties {
    
    struct PlayerTime: Decodable {
        public var hours: Int = 0
        public var milliseconds: Int = 0
        public var minutes: Int = 0
        public var seconds: Int = 0
    }
    
    struct PlayerAudioStream: Decodable {
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
    
    struct PlayerSubtitle: Decodable {
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
    
    struct PlayerVideoStream: Decodable {
        public var codec: String = ""
        public var height: Int = 0
        public var index: Int = 0
        public var language: String = ""
        public var name: String = ""
        public var width: Int = 0
    }
    
    enum PlayerRepeatMode: String, Decodable {
        case off = "off"
        case one = "one"
        case all = "all"
    }
    
    enum PlayerType: String, Decodable {
        /// The audio player
        case audio
        /// The video player
        case video
        /// The picture player
        case picture
    }
}

extension PlayerProperties {
    
    /// The 'root' Codings Keys
    enum CodingKeys: String, CodingKey {
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
        case media = "type"
    }
}

extension PlayerProperties {
    
    /// Custom init for the Player Item because some values will be changed to enums
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        audioStreams = try container.decode([PlayerAudioStream].self, forKey: .audioStreams)
        cachePercentage = try container.decode(Double.self, forKey: .cachePercentage)
        canChangeSpeed = try container.decode(Bool.self, forKey: .canChangeSpeed)
        canMove = try container.decode(Bool.self, forKey: .canMove)
        canRepeat = try container.decode(Bool.self, forKey: .canRepeat)
        canRotate = try container.decode(Bool.self, forKey: .canRotate)
        canSeek = try container.decode(Bool.self, forKey: .canSeek)
        canShuffle = try container.decode(Bool.self, forKey: .canShuffle)
        canZoom = try container.decode(Bool.self, forKey: .canZoom)
        currentAudioStream = try container.decode(PlayerAudioStream.self, forKey: .currentAudioStream)
        /// - Note: 'currentSubtitle' is optional; only video has it
        currentSubtitle = try container.decodeIfPresent(PlayerSubtitle.self, forKey: .currentSubtitle) ?? currentSubtitle
        /// - Note: 'currentSubtitle' is optional; only video has it
        currentVideoStream = try container.decodeIfPresent(PlayerVideoStream.self, forKey: .currentVideoStream) ?? currentVideoStream
        live = try container.decode(Bool.self, forKey: .live)
        partymode = try container.decode(Bool.self, forKey: .partymode)
        percentage = try container.decode(Double.self, forKey: .percentage)
        playlistID = try container.decode(Int.self, forKey: .playlistID)
        playlistPosition = try container.decode(Int.self, forKey: .playlistPosition)
        if let rawValue = try container.decodeIfPresent(String.self, forKey: .repeating),
           let method = PlayerRepeatMode(rawValue: rawValue) {
            self.repeating = method
        }
        shuffled = try container.decode(Bool.self, forKey: .shuffled)
        speed = try container.decode(Int.self, forKey: .speed)
        subtitleEnabled = try container.decode(Bool.self, forKey: .subtitleEnabled)
        time = try container.decode(PlayerTime.self, forKey: .time)
        timeTotal = try container.decode(PlayerTime.self, forKey: .timeTotal)
        if let rawValue = try container.decodeIfPresent(String.self, forKey: .media),
           let media = PlayerType(rawValue: rawValue) {
            self.media = media
        }
    }
}
