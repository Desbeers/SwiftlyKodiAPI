//
//  Setting+ID.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Setting {
    
    /// The ID of the setting (Global Kodi Type)
    enum ID: String, Codable {
        /// A setting SwiftlyKodiAPI doesn't know about
        case unknown
        /// ReplayGain (off, track or album)
        case musicPlayerReplayGainType = "musicplayer.replaygaintype"
        /// Crossfade between songs
        case musicplayerCrossfade = "musicplayer.crossfade"
        
        case musicplayerCrossfadeAlbumTracks = "musicplayer.crossfadealbumtracks"
    }
}
