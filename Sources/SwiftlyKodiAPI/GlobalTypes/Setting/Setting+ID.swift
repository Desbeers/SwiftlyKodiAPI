//
//  Setting+ID.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Setting {
    
    /// The ID of the setting (SwiftlyKodi Type)
    enum ID: String, Codable {
        /// A setting SwiftlyKodiAPI doesn't know about
        case unknown
        
        /// # services + general
        
        case servicesDevicename = "services.devicename"
        
        /// # player + musicplayer
        
        /// Read the ReplayGain information encoded in your audio files
        case musicPlayerReplayGainType = "musicplayer.replaygaintype"
        /// Reference volume (PreAmp level) to use for files with encoded ReplayGain information
        case musicplayerReplayGainPreamp = "musicplayer.replaygainpreamp"
        /// Reference volume (PreAmp level) to use for files without encoded ReplayGain information
        case musicplayerReplayGainNoGainPreamp = "musicplayer.replaygainnogainpreamp"
        /// Play file at lower volume, if necessary, to avoid audio limiting clipping protection
        case musicplayerReplayGainAvoidClipping = "musicplayer.replaygainavoidclipping"
        /// Crossfade between songs
        case musicplayerCrossfade = "musicplayer.crossfade"
        /// Allow crossfading to occur when both tracks are from the same album
        case musicplayerCrossfadeAlbumTracks = "musicplayer.crossfadealbumtracks"
    }
}
