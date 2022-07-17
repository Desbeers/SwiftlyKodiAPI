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
            await Playlist.clear(playlistID: .video)
            await Playlist.add(musicVideos: [self])
            await Player.open(playlistID: .video)
        }
    }
}
