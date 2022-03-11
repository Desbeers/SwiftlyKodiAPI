//
//  File.swift
//  
//
//  Created by Nick Berendsen on 11/03/2022.
//

import Foundation

extension KodiConnector {
    
    /// An enum with the different kinds of Kodi notifications we can receive
    public enum NotificationMethod: String {
        
        /// # General notifications
        
        /// Notify all other connected clients
        case notifyAll = "JSONRPC.NotifyAll"
        /// Custom notification
        case otherNewQueue = "Other.NewQueue"
        
        /// # Player Notifications
        
        /// Notification that the player starts playing on the host
        case playerOnPlay = "Player.OnPlay"
        /// Notification that the player has stopped on the host
        case playerOnStop = "Player.OnStop"
        /// Notification that the player properties have changed
        case playerOnPropertyChanged = "Player.OnPropertyChanged"
        /// Notification that the player resumes playing on the host
        case playerOnResume = "Player.OnResume"
        /// Notification that the player will pause on the host
        case playerOnPause = "Player.OnPause"
        /// Notification that the player starts playing on the host
        case playerOnAVStart = "Player.OnAVStart"
        /// Notification that the player speed as changed on the host
        case playerOnSpeedChanged = "Player.OnSpeedChanged"
        
        /// # Audio notifications
        
        /// Notification that the audio library has changed
        case audioLibraryOnUpdate = "AudioLibrary.OnUpdate"
        /// Notification that the audio library will be scanned
        case audioLibraryOnScanStarted = "AudioLibrary.OnScanStarted"
        /// Notification that the audio library has finnished scannning
        case audioLibraryOnScanFinished = "AudioLibrary.OnScanFinished"
    }
}
