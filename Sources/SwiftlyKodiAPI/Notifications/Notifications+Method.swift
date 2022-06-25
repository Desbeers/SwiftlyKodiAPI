//
//  Notifications+Method.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {
    
    /// An enum with the different kinds of Kodi notifications we can receive
    public enum NotificationMethod: String {
        
        /// # General notifications
        
        /// An unsupported method
        case unknown
        
        /// # Application notifications
        
        /// The volume of the application has changed
        case applicationOnVolumeChanged = "Application.OnVolumeChanged"
        
        /// # JSONRPC
        
        /// Notify all other connected clients
        case notifyAll = "JSONRPC.NotifyAll"
        
        /// # Player notifications
        
        /// Audio- or videostream has changed
        case playerOnAVChange = "Player.OnAVChange"
        /// Playback of a media item has been started and first frame is available
        case playerOnAVStart = "Player.OnAVStart"
        /// Playback of a media item has been paused
        case playerOnPause = "Player.OnPause"
        /// Playback of a media item has been started or the playback speed has changed
        case playerOnPlay = "Player.OnPlay"
        /// A property of the playing items has changed
        case playerOnPropertyChanged = "Player.OnPropertyChanged"
        /// Playback of a media item has been resumed
        case playerOnResume = "Player.OnResume"
        /// The playback position has been changed
        case playerOnSeek = "Player.OnSeek"
        /// Speed of the playback of a media item has been changed
        case playerOnSpeedChanged = "Player.OnSpeedChanged"
        /// Playback of a media item has been stopped
        case playerOnStop = "Player.OnStop"
        
        /// # Playlist notifications
        
        /// A playlist item has been added
        case playlistOnAdd = "Playlist.OnAdd"
        /// A playlist item has been cleared
        case playlistOnClear = "Playlist.OnClear"
        /// A playlist item has been removed
        case playlistOnRemove = "Playlist.OnRemove"
        
        ///# Video library notifications
        
        /// The video library has been cleaned.
        case videoLibraryOnCleanFinished = "VideoLibrary.OnCleanFinished"
        /// A video library clean operation has started.
        case videoLibraryOnCleanStarted = "VideoLibrary.OnCleanStarted"
        /// A video library export has finished.
        case videoLibraryOnExport = "VideoLibrary.OnExport"
        /// The video library has been refreshed and a home screen reload might be necessary.
        case videoLibraryOnRefresh = "VideoLibrary.OnRefresh"
        /// A video item has been removed.
        case videoLibraryOnRemove = "VideoLibrary.OnRemove"
        /// Scanning the video library has been finished.
        case videoLibraryOnScanFinished = "VideoLibrary.OnScanFinished"
        /// A video library scan has started.
        case videoLibraryOnScanStarted = "VideoLibrary.OnScanStarted"
        /// A video item has been updated.
        case videoLibraryOnUpdate = "VideoLibrary.OnUpdate"
        
        /// # Audio library notifications
        
        /// The audio library has been cleaned
        case audioLibraryOnCleanFinished = "AudioLibrary.OnCleanFinished"
        /// An audio library clean operation has started
        case audioLibraryOnCleanStarted = "AudioLibrary.OnCleanStarted"
        /// An audio library export has finished
        case audioLibraryOnExport = "AudioLibrary.OnExport"
        /// An audio item has been removed
        case audioLibraryOnRemove = "AudioLibrary.OnRemove"
        /// Scanning the audio library has been finished
        case audioLibraryOnScanFinished = "AudioLibrary.OnScanFinished"
        /// An audio library scan has started
        case audioLibraryOnScanStarted = "AudioLibrary.OnScanStarted"
        /// An audio item has been updated
        case audioLibraryOnUpdate = "AudioLibrary.OnUpdate"
    }
}
