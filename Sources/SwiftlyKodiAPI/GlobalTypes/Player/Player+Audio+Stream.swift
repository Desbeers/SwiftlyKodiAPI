//
//  Player+Audio+Stream.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

extension Player.Audio {

    /// Audio stream details of the player (Global Kodi Type)
    public struct Stream: Decodable {

        /// # Player.Audio.Stream

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

        /// # Coding keys

        enum CodingKeys: String, CodingKey {
            case bitrate, channels, codec, index
            case isDefault = "isdefault"
            case isImpaired = "isimpaired"
            case isOriginal = "isoriginal"
            case language, name, samplerate
        }
    }
}
