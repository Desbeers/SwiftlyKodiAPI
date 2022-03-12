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
        
//        /// Notify all other connected clients
//        case notifyAll = "JSONRPC.NotifyAll"
//        /// Custom notification
//        case otherNewQueue = "Other.NewQueue"
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
        
        /// Cleans the audio library from non-existent items
        case audioLibraryClean = "AudioLibrary.Clean"
        /// Exports all items from the audio library
        case audioLibraryExport = "AudioLibrary.Export"
        /// Retrieve details about a specific album
        case audioLibraryGetAlbumDetails = "AudioLibrary.GetAlbumDetails"
        /// Retrieve all albums from specified artist (and role) or that has songs of the specified genre
        case audioLibraryGetAlbums = "AudioLibrary.GetAlbums"
        /// Retrieve details about a specific artist
        case audioLibraryGetArtistDetails = "AudioLibrary.GetArtistDetails"
        /// Retrieve all artists
        case audioLibraryGetArtists = "AudioLibrary.GetArtists"
        /// Retrieve all potential art URLs for a media item by art type
        case audioLibraryGetAvailableArt = "AudioLibrary.GetAvailableArt"
        /// Retrieve a list of potential art types for a media item
        case audioLibraryGetAvailableArtTypes = "AudioLibrary.GetAvailableArtTypes"
        /// Retrieve all genres
        case audioLibraryGetGenres = "AudioLibrary.GetGenres"
        /// Retrieves the values of the music library properties
        case audioLibraryGetProperties = "AudioLibrary.GetProperties"
        /// Retrieve recently added albums
        case audioLibraryGetRecentlyAddedAlbums = "AudioLibrary.GetRecentlyAddedAlbums"
        /// Retrieve recently added songs
        case audioLibraryGetRecentlyAddedSongs = "AudioLibrary.GetRecentlyAddedSongs"
        /// Retrieve recently played albums
        case audioLibraryGetRecentlyPlayedAlbums = "AudioLibrary.GetRecentlyPlayedAlbums"
        /// Retrieve recently played songs
        case audioLibraryGetRecentlyPlayedSongs = "AudioLibrary.GetRecentlyPlayedSongs"
        /// Retrieve all contributor roles
        case audioLibraryGetRoles = "AudioLibrary.GetRoles"
        /// Retrieve details about a specific song
        case audioLibraryGetSongDetails = "AudioLibrary.GetSongDetails"
        /// Retrieve all songs from specified album, artist or genre
        case audioLibraryGetSongs = "AudioLibrary.GetSongs"
        /// Get all music sources, including unique ID
        case audioLibraryGetSources = "AudioLibrary.GetSources"
        /// Scans the audio sources for new library items
        case audioLibraryScan = "AudioLibrary.Scan"
        /// Update the given album with the given details
        case audioLibrarySetAlbumDetails = "AudioLibrary.SetAlbumDetails"
        /// Update the given artist with the given details
        case audioLibrarySetArtistDetails = "AudioLibrary.SetArtistDetails"
        /// Update the given song with the given details
        case audioLibrarySetSongDetails = "AudioLibrary.SetSongDetails"
        
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
