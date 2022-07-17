//
//  AudioLibrary+Songs+Extensions.swift
//  
//
//  Created by Nick Berendsen on 16/07/2022.
//

import Foundation

extension Audio.Details.Song {
    
    /// Play an  ``Audio/Details/Song`` item
    public func play() {
        Task {
            await Playlist.clear()
            await Playlist.add(songs: [self])
            await Player.open()
        }
    }
}

extension Array where Element == Audio.Details.Song {
    
    /// Play an array of ``Audio/Details/Song`` items
    public func play(shuffle: Bool = false) {
        Task {
            await Playlist.clear()
            await Playlist.add(songs: self)
            await Player.open(shuffle: shuffle)
        }
    }
}
