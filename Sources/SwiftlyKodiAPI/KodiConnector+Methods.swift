//
//  KodiConnector+Methods.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {
    
    /// Kodi methods used by KodiAPI
    public enum Method: String {
        
        /// # General
        
        /// Notify all other connected clients
        case notifyAll = "JSONRPC.NotifyAll"
        /// Custom notification
        case otherNewQueue = "Other.NewQueue"
        /// Get host properties
        case applicationGetProperties = "Application.GetProperties"
        /// Quit the host
        case applicationQuit = "Application.Quit"
        /// Set the volume on the host
        case applicationSetVolume = "Application.SetVolume"
        /// Notification that the volume has changed
        case applicationOnVolumeChanged = "Application.OnVolumeChanged"
        /// Toggle the mute
        case applicationSetMute = "Application.SetMute"
        /// Set a setting on the host
        case settingsSetSettingvalue = "Settings.SetSettingvalue"
        
        /// # Video
        
        /// Get movies from the host
        case videoLibraryGetMovies = "VideoLibrary.GetMovies"
        /// Get movie sets from the host
        case videoLibraryGetMovieSets = "VideoLibrary.GetMovieSets"
        /// Get video genres from the host
        case videoLibraryGetGenres = "VideoLibrary.GetGenres"
        /// Get TV shows from the host
        case videoLibraryGetTVShows = "VideoLibrary.GetTVShows"
        /// Get episodes from the host
        case videoLibraryGetEpisodes = "VideoLibrary.GetEpisodes"
        /// Get music videos from the host
        case videoLibraryGetMusicVideos = "VideoLibrary.GetMusicVideos"
        
        /// Set details for a movie
        case videoLibrarySetMovieDetails = "VideoLibrary.SetMovieDetails"
        /// Set details for a movie set
        case videoLibrarySetMovieSetDetails = "VideoLibrary.SetMovieSetDetails"
        /// Set details for a TV show
        case videoLibrarySetTVShowDetails = "VideoLibrary.SetTVShowDetails"
        /// Set details for an episode
        case videoLibrarySetEpisodeDetails = "VideoLibrary.SetEpisodeDetails"
        /// Set details for a music video
        case videoLibrarySetMusicVideoDetails = "VideoLibrary.SetMusicVideoDetails"
        
        /// # Audio
        
        /// Scan the library on the host
        case audioLibraryScan = "AudioLibrary.Scan"
        /// Get the library properties from the host
        case audioLibraryGetProperties = "AudioLibrary.GetProperties"
        /// Get artists from the host
        case audioLibraryGetArtists = "AudioLibrary.GetArtists"
        /// Get albums from the host
        case audioLibraryGetAlbums = "AudioLibrary.GetAlbums"
        /// Get songs from the host
        case audioLibraryGetSongs = "AudioLibrary.GetSongs"
        /// Get details of one song from the host
        case audioLibraryGetSongDetails = "AudioLibrary.GetSongDetails"
        /// Set details of a song on the host
        case audioLibrarySetSongDetails = "AudioLibrary.SetSongDetails"
        /// Get genres from the host
        case audioLibraryGetGenres = "AudioLibrary.GetGenres"
        
        /// # Audio Notifications
        
        /// Notification that the audio library has changed
        case audioLibraryOnUpdate = "AudioLibrary.OnUpdate"
        /// Notification that the audio library will be scanned
        case audioLibraryOnScanStarted = "AudioLibrary.OnScanStarted"
        /// Notification that the audio library has finnished scannning
        case audioLibraryOnScanFinished = "AudioLibrary.OnScanFinished"
        
        /// # Player
        
        /// Turn partymode on or off
        case playerSetPartymode = "Player.SetPartymode"
        /// Set the player shuffle modus on the host
        case playerSetShuffle = "Player.SetShuffle"
        /// Set the player repeat modus on the host
        case playerSetRepeat = "Player.SetRepeat"
        /// Play or pause the player on the host
        case playerPlayPause = "Player.PlayPause"
        /// Open the player on the host
        case playerOpen = "Player.Open"
        /// Stop the player on the host
        case playerStop = "Player.Stop"
        /// Goto an player item on the host
        case playerGoTo = "Player.GoTo"
        /// Get the player properties from the host
        case playerGetProperties = "Player.GetProperties"
        /// Get the current player item from the host
        case playerGetItem = "Player.GetItem"
        /// Notification that the player speed as changed on the host
        case playerOnSpeedChanged = "Player.OnSpeedChanged"
        
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
        
        /// # Playlists
        
        /// Clear the playlist on the host
        case playlistClear = "Playlist.Clear"
        /// Add an item to the playlist on the host
        case playlistAdd = "Playlist.Add"
        /// Remove an item from the playlist on the host
        case playlistRemove = "Playlist.Remove"
        /// Swap an item in the playlist on the host
        case playlistSwap = "Playlist.Swap"
        /// Get a list of items from a playlist on the host
        case playlistGetItems = "Playlist.GetItems"
        
        /// # Files
        
        /// Get a directory list from the host
        case filesGetDirectory = "Files.GetDirectory"
    }
}
