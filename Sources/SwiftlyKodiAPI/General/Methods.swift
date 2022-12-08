//
//  KodiConnector+Methods.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

/// Kodi methods used by KodiAPI
enum Methods: String {

    /// # Application

    /// Retrieves the values of the given properties
    case applicationGetProperties = "Application.GetProperties"
    /// Quit application
    case applicationQuit = "Application.Quit"
    /// Toggle mute/unmute
    case applicationSetMute = "Application.SetMute"
    /// Set the current volume
    case applicationSetVolume = "Application.SetVolume"

    /// # Audio library

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

    /// # Files

    /// Get the directories and files in the given directory
    case filesGetDirectory = "Files.GetDirectory"
    /// Provides a way to download a given file
    case filesPrepareDownload = "Files.PrepareDownload"

    /// # JSONRPC

    /// Notify all other connected clients
    case notifyAll = "JSONRPC.NotifyAll"

    /// # Player

    /// Add subtitle to the player
    case playerAddSubtitle = "Player.AddSubtitle"
    /// Returns all active players
    case playerGetActivePlayers = "Player.GetActivePlayers"
    /// Retrieves the currently played item
    case playerGetItem = "Player.GetItem"
    /// Get a list of available players
    case playerGetPlayers = "Player.GetPlayers"
    /// Retrieves the values of the given properties
    case playerGetProperties = "Player.GetProperties"
    /// Get view mode of video player
    case playerGetViewMode = "Player.GetViewMode"
    /// Go to previous/next/specific item in the playlist
    case playerGoTo = "Player.GoTo"
    /// If picture is zoomed move viewport left/right/up/down otherwise skip previous/next
    case playerMove = "Player.Move"
    /// Start playback of either the playlist with the given ID,
    /// a slideshow with the pictures from the given directory
    /// or a single file or an item from the database
    case playerOpen = "Player.Open"
    /// Pauses or unpause playback and returns the new state
    case playerPlayPause = "Player.PlayPause"
    /// Rotates current picture
    case playerRotate = "Player.Rotate"
    /// Seek through the playing item
    case playerSeek = "Player.Seek"
    /// Set the audio stream played by the player
    case playerSetAudioStream = "Player.SetAudioStream"
    /// Toggle partymode on or off
    case playerSetPartymode = "Player.SetPartymode"
    /// Set the repeat mode of the player
    case playerSetRepeat = "Player.SetRepeat"
    /// Shuffle/Unshuffle items in the player
    case playerSetShuffle = "Player.SetShuffle"
    /// Set the speed of the current playback
    case playerSetSpeed = "Player.SetSpeed"
    /// Set the subtitle displayed by the player
    case playerSetSubtitle = "Player.SetSubtitle"
    /// Set the video stream played by the player
    case playerSetVideoStream = "Player.SetVideoStream"
    /// Set view mode of video player
    case playerSetViewMode = "Player.SetViewMode"
    /// Stops playback
    case playerStop = "Player.Stop"
    /// Zoom current picture
    case playerZoom = "Player.Zoom"

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

    /// # Settings

    /// Retrieves all setting categories
    case settingsGetSections = "Settings.GetSections"
    /// Retrieves all setting categories
    case settingsGetCategories = "Settings.GetCategories"
    /// Retrieves all settings
    case settingsGetSettings = "Settings.GetSettings"
    /// Set a setting on the host
    case settingsSetSettingvalue = "Settings.SetSettingvalue"

    /// # Video library

    /// Cleans the video library for non-existent items
    case videoLibraryClean = "VideoLibrary.Clean"
    /// Exports all items from the video library
    case videoLibraryExport = "VideoLibrary.Export"
    /// Retrieve all potential art URLs for a media item by art type
    case videoLibraryGetAvailableArt = "VideoLibrary.GetAvailableArt"
    /// Retrieve a list of potential art types for a media item
    case videoLibraryGetAvailableArtTypes = "VideoLibrary.GetAvailableArtTypes"
    /// Retrieve details about a specific tv show episode
    case videoLibraryGetEpisodeDetails = "VideoLibrary.GetEpisodeDetails"
    /// Retrieve all tv show episodes
    case videoLibraryGetEpisodes = "VideoLibrary.GetEpisodes"
    /// Retrieve all genres
    case videoLibraryGetGenres = "VideoLibrary.GetGenres"
    /// Retrieve all in progress tvshows
    case videoLibraryGetInProgressTVShows = "VideoLibrary.GetInProgressTVShows"
    /// Retrieve details about a specific movie
    case videoLibraryGetMovieDetails = "VideoLibrary.GetMovieDetails"
    /// Retrieve details about a specific movie set
    case videoLibraryGetMovieSetDetails = "VideoLibrary.GetMovieSetDetails"
    /// Retrieve all movie sets
    case videoLibraryGetMovieSets = "VideoLibrary.GetMovieSets"
    /// Retrieve all movies
    case videoLibraryGetMovies = "VideoLibrary.GetMovies"
    /// Retrieve details about a specific music video
    case videoLibraryGetMusicVideoDetails = "VideoLibrary.GetMusicVideoDetails"
    /// Retrieve all music videos
    case videoLibraryGetMusicVideos = "VideoLibrary.GetMusicVideos"
    /// Retrieve all recently added tv episodes
    case videoLibraryGetRecentlyAddedEpisodes = "VideoLibrary.GetRecentlyAddedEpisodes"
    /// Retrieve all recently added movies
    case videoLibraryGetRecentlyAddedMovies = "VideoLibrary.GetRecentlyAddedMovies"
    /// Retrieve all recently added music videos
    case videoLibraryGetRecentlyAddedMusicVideos = "VideoLibrary.GetRecentlyAddedMusicVideos"
    /// Retrieve details about a specific tv show season
    case videoLibraryGetSeasonDetails = "VideoLibrary.GetSeasonDetails"
    /// Retrieve all tv seasons
    case videoLibraryGetSeasons = "VideoLibrary.GetSeasons"
    /// Retrieve details about a specific tv show
    case videoLibraryGetTVShowDetails = "VideoLibrary.GetTVShowDetails"
    /// Retrieve all tv shows
    case videoLibraryGetTVShows = "VideoLibrary.GetTVShows"
    /// Retrieve all tags
    case videoLibraryGetTags = "VideoLibrary.GetTags"
    /// Refresh the given episode in the library
    case videoLibraryRefreshEpisode = "VideoLibrary.RefreshEpisode"
    /// Refresh the given movie in the library
    case videoLibraryRefreshMovie = "VideoLibrary.RefreshMovie"
    /// Refresh the given music video in the library
    case videoLibraryRefreshMusicVideo = "VideoLibrary.RefreshMusicVideo"
    /// Refresh the given tv show in the library
    case videoLibraryRefreshTVShow = "VideoLibrary.RefreshTVShow"
    /// Removes the given episode from the library
    case videoLibraryRemoveEpisode = "VideoLibrary.RemoveEpisode"
    /// Removes the given movie from the library
    case videoLibraryRemoveMovie = "VideoLibrary.RemoveMovie"
    /// Removes the given music video from the library
    case videoLibraryRemoveMusicVideo = "VideoLibrary.RemoveMusicVideo"
    /// Removes the given tv show from the library
    case videoLibraryRemoveTVShow = "VideoLibrary.RemoveTVShow"
    /// Scans the video sources for new library items
    case videoLibraryScan = "VideoLibrary.Scan"
    /// Update the given episode with the given details
    case videoLibrarySetEpisodeDetails = "VideoLibrary.SetEpisodeDetails"
    /// Update the given movie with the given details
    case videoLibrarySetMovieDetails = "VideoLibrary.SetMovieDetails"
    /// Update the given movie set with the given details
    case videoLibrarySetMovieSetDetails = "VideoLibrary.SetMovieSetDetails"
    /// Update the given music video with the given details
    case videoLibrarySetMusicVideoDetails = "VideoLibrary.SetMusicVideoDetails"
    /// Update the given season with the given details
    case videoLibrarySetSeasonDetails = "VideoLibrary.SetSeasonDetails"
    /// Update the given tvshow with the given details
    case videoLibrarySetTVShowDetails = "VideoLibrary.SetTVShowDetails"

    /// ## XBMC

    /// Retrieve info booleans about Kodi and the system
    case xbmcGetInfoBooleans = "XBMC.GetInfoBooleans"

}
