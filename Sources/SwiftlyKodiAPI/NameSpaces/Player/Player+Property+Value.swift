//
//  Player+Property+Value.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Player.Property {
    
    /// Values of the player properties (Global Kodi Type)
    public struct Value: Decodable {
        public var audioStreams: [Player.Audio.Stream] = []
        public var cachePercentage: Double = 0.0
        public var canChangeSpeed: Bool = false
        public var canMove: Bool = false
        public var canRepeat: Bool = false
        public var canRotate: Bool = false
        public var canSeek: Bool = false
        public var canShuffle: Bool = false
        public var canZoom: Bool = false
        public var currentAudioStream = Player.Audio.Stream()
        public var currentSubtitle: Player.Subtitle?
        public var currentVideoStream: Player.Video.Stream?
        public var mediaType: Player.MediaType = .none
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
        /// The Codings Keys
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
            case mediaType = "type"
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
        }
    }
}
