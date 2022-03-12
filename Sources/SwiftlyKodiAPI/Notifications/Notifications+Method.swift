//
//  File.swift
//  
//
//  Created by Nick Berendsen on 11/03/2022.
//

import Foundation

//extension KodiConnector {
    
    /// An enum with the different kinds of Kodi notifications we can receive
    public enum NotificationMethod: String {
        
        /// # General notifications
        
        /// An unsupported method
        case unknown
        
        /// Notify all other connected clients
        case notifyAll = "JSONRPC.NotifyAll"
        /// Custom notification
        case otherNewQueue = "Other.NewQueue"
        
        /// # Application notifications
        
        /// Notification that the volume has changed
        case applicationOnVolumeChanged = "Application.OnVolumeChanged"
        
        /// # Player Notifications
        
        /// Audio- or videostream has changed.
        /// If there is no ID available extra information will be provided.
        case playerOnAVChange = "Player.OnAVChange"
        /// Playback of a media item has been started and first frame is available.
        /// If there is no ID available extra information will be provided.
        case playerOnAVStart = "Player.OnAVStart"
        /// Playback of a media item has been paused.
        /// If there is no ID available extra information will be provided.
        case playerOnPause = "Player.OnPause"
        /// Playback of a media item has been started or the playback speed has changed.
        /// If there is no ID available extra information will be provided.
        case playerOnPlay = "Player.OnPlay"
        /// A property of the playing items has changed.
        case playerOnPropertyChanged = "Player.OnPropertyChanged"
        /// Playback of a media item has been resumed.
        /// If there is no ID available extra information will be provided.
        case playerOnResume = "Player.OnResume"
        /// The playback position has been changed.
        /// If there is no ID available extra information will be provided.
        case playerOnSeek = "Player.OnSeek"
        /// Speed of the playback of a media item has been changed.
        /// If there is no ID available extra information will be provided.
        case playerOnSpeedChanged = "Player.OnSpeedChanged"
        /// Playback of a media item has been stopped.
        /// If there is no ID available extra information will be provided.
        case playerOnStop = "Player.OnStop"
        
        /// # Audio notifications
        
        /// Notification that the audio library has changed
        case audioLibraryOnUpdate = "AudioLibrary.OnUpdate"
        /// Notification that the audio library will be scanned
        case audioLibraryOnScanStarted = "AudioLibrary.OnScanStarted"
        /// Notification that the audio library has finnished scannning
        case audioLibraryOnScanFinished = "AudioLibrary.OnScanFinished"
    }
//}
