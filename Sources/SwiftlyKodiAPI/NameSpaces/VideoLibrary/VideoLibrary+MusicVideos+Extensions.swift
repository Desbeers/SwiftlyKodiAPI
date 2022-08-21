//
//  VideoLibrary+MusicVideos+Extensions.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
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
            let album = element.album
            if album == "" || !knownAlbums.contains(album) {
                knownAlbums.insert(album)
                return true
            }
            /// This set is already in the list
            return false
        }
    }
}
