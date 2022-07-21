//
//  Player+State.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Player {
    
    /// The state of the player (SwiftlyKodi Type)
    struct State {
        /// The properties of the player
        public var properies = Player.Property.Value()
        /// Current item in the player
        public var currentItem: (any KodiItem)?
        /// The audio playlist
        public var audioPlaylist: [(any KodiItem)]?
        /// The video playlist
        public var videoPlaylist: [(any KodiItem)]?
        /// The current playlist
        public var currentPlaylist: [(any KodiItem)]? {
            switch properies.playlistID {
            case .video:
                return videoPlaylist
            case .audio:
                return audioPlaylist
            default:
                return nil
            }
        }
    }
}
