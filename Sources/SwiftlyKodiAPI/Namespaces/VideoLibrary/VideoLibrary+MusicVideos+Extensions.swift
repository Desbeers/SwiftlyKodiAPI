//
//  VideoLibrary+MusicVideos+Extensions.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import Foundation

extension Video.Details.MusicVideo {

    /// Play a  ``Video/Details/MusicVideo`` item
    public func play() {
        Task {
            /// Check if this song is in the current playlist
            if let position = self.playlistID {
                Player.goTo(playerID: .video, position: position)
            } else {
                Playlist.clear(playlistID: .video)
                await Playlist.add(musicVideos: [self])
                Player.open(playlistID: .video)
            }
        }
    }

    /// Refresh a  ``Video/Details/MusicVideo`` item
    public func refresh() {
        Task {
            await VideoLibrary.refreshMusicVideo(musicVideo: self)
        }
    }
}

extension Array where Element == Video.Details.MusicVideo {

    /// Search an array of ``Video/Details/MusicVideo`` by the a query
    /// - Parameter query: The search query
    /// - Returns: An array of ``Video/Details/MusicVideo``
    public func search(_ query: String) -> [Video.Details.MusicVideo] {
        let searchMatcher = Search.Matcher(query: query)
        return self.filter { musicVideos in
            return searchMatcher.matches(musicVideos.search)
        }
    }
}

extension Array where Element == Video.Details.MusicVideo {

    /// Play an array of ``Video.Details.MusicVideo``
    public func play(shuffle: Bool = false) {
        Task {
            Playlist.clear(playlistID: .video)
            await Playlist.add(musicVideos: self)
            Player.open(playlistID: .video, shuffle: shuffle)
        }
    }
}

extension Array where Element == Video.Details.MusicVideo {

    /// Filter the music videos to have only one video representing an album
    /// - Returns: A list with music videos without duplicated albums
    public func uniqueAlbum() -> [Video.Details.MusicVideo] {
        var knownAlbums = Set<String>()
        return self.filter { element -> Bool in
            let album = element.album.isEmpty ? element.title : element.album
            if !knownAlbums.contains(album) {
                knownAlbums.insert(album)
                return true
            }
            /// This set is already in the list
            return false
        }
    }
}

extension Array where Element == Video.Details.MusicVideo {

    /// Swap Music Videos for Albums
    ///
    /// Music Videos that are part of an album will be added as Album
    /// This function is expecting music videos from one artist only
    /// - Parameter artist: The artist of the videos
    /// - Returns: An array of ``KodiItem``
    public func swapMusicVideosForAlbums(artist: Audio.Details.Artist) -> [any KodiItem] {
        /// Get all album titles
        let musicVideoAlbums = Set(self.map(\.album))
        /// The list of item to return
        var items: [any KodiItem] = []
        /// Add the albums
        for album in musicVideoAlbums where album != "" {
            let musicVideos = self.filter { $0.album == album }
            if let musicVideo = musicVideos.first {
                switch musicVideos.count {
                case 1:
                    /// Add it as normal Music Video
                    items.append(musicVideo)
                default:
                    /// Add it as Music Video Album
                    items.append(Video.Details.MusicVideoAlbum(artist: artist, musicVideos: musicVideos))
                }
            }
        }
        /// Return the new array
        return (self.filter { $0.album == "" } + items)
    }
}
