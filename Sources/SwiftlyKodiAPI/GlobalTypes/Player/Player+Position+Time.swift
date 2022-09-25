//
//  Player+Position+Time.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension Player.Position {
    
    /// The time details of the player (Global Kodi Type)
    public struct Time: Decodable, Equatable {
        public var hours: Int = 0
        public var milliseconds: Int = 0
        public var minutes: Int = 0
        public var seconds: Int = 0
        public var total: Int {
            return (hours * 3600) + (minutes * 60) + seconds
        }
    }
}
