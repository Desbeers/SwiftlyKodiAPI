//
//  Player+Position+Time.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Player.Position {
    
    /// The time details of the player (Global Kodi Type)
    public struct Time: Decodable {
        public var hours: Int = 0
        public var milliseconds: Int = 0
        public var minutes: Int = 0
        public var seconds: Int = 0
    }
}
