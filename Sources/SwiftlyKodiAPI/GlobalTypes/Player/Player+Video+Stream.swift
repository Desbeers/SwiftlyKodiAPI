//
//  Player+Video+Stream.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Player.Video {

    /// Video stream details of the player (Global Kodi Type)
    public struct Stream: Decodable {

        /// # Player.Video.Stream

        public var codec: String = ""
        public var height: Int = 0
        public var index: Int = 0
        public var language: String = ""
        public var name: String = ""
        public var width: Int = 0
    }}
