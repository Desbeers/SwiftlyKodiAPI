//
//  KodiPlayer.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import SwiftUI

/// An Observable Class that contains all the Player information (SwiftlyKodi Type)
///
/// - The properties of the player
/// - The optional current item in the player
/// - The current audio playlist
/// - The current video playlist
/// - The volume of the player
///
/// - Note: Volume is part of the Application properties but it makes sense here
public final class KodiPlayer: ObservableObject {
    
    // MARK: Constants and Variables
    
    /// The shared instance of this KodiPlayer class
    public static let shared = KodiPlayer()
    /// Debounced tasks
    var task = Tasks()
    
    // MARK: Published properties
    
    /// The properties of the player
    @Published public private(set) var properties = Player.Property.Value()
    /// The optional current item in the player
    @Published public private(set) var currentItem: (any KodiItem)?
    /// The current audio playlist
    @Published public private(set) var audioPlaylist: [(any KodiItem)]?
    /// The current video playlist
    @Published public private(set) var videoPlaylist: [(any KodiItem)]?
    /// The time of latest playlist update
    /// - Note: SwiftUI can't observe the playlists because they have Protocol items
    @Published public private(set) var playlistUpdate = Date()
    /// The volume setting of the application
    /// - Note: This is an Application property but it makes more sense here
    @Published public var volume: Double = 0
    /// Bool if the volume of the application is muted or not
    /// - Note: This is an Application property but it makes more sense here
    @Published public private(set) var muted: Bool = false
    
    // MARK: Calculated stuff
    
    /// The current playlist, based on the current ``Playlist/ID``
    public var currentPlaylist: [(any KodiItem)]? {
        switch properties.playlistID {
        case .video:
            return videoPlaylist
        case .audio:
            return audioPlaylist
        default:
            return nil
        }
    }
    
    // MARK: Init
    
    /// Private init to make sure we have only one instance
    private init() { }
}

extension KodiPlayer {
    

}

// MARK: Kodi Player setters

extension KodiPlayer {
    
    @MainActor func setApplicationProperties(properties: Application.Property.Value) {
        volume = properties.volume
        muted = properties.muted
    }
    
    @MainActor func setProperties(properties: Player.Property.Value) {
        self.properties = properties
    }
    
    @MainActor func setAudioPlaylist(playlist: [any KodiItem]) {
        audioPlaylist = playlist
    }
    
    @MainActor func setVideoPlaylist(playlist: [any KodiItem]) {
        videoPlaylist = playlist
    }
    
    @MainActor func setPlaylistUpdate() {
        playlistUpdate = Date()
    }
    
    @MainActor func setCurrentItem(item: (any KodiItem)?) {
        currentItem = item
    }
}
