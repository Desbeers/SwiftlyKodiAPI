//
//  KodiConnector+Player.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

extension KodiConnector {

    /// Get the first active player ID
    /// - Returns: The active `playerID`, if any, else `nil`
    func getPlayerID() async -> Player.ID? {
        if let players = await Player.getActivePlayers(host: host), let activePlayer = players.first {
            return activePlayer
        }
        return nil
    }

    /// Get the properties of the player
    func getPlayerProperties() async {
        await task.getPlayerProperties.submit {
            var properties = Player.Property.Value()
            /// Check if we have an active player
            if let playerID = await self.getPlayerID() {
                properties = await Player.getProperties(host: self.host, playerID: playerID)
            }
            await self.player.setProperties(properties: properties)
        }
    }

    /// Get the optional current item of the player
    func getPlayerItem() async {
        await task.getPlayerItem.submit {
            var currentItem: (any KodiItem)?
            /// Check if we have an active player
            if let playerID = await self.getPlayerID() {
                currentItem = await Player.getItem(host: self.host, playerID: playerID)
            }
            await self.player.setCurrentItem(item: currentItem)
        }
    }

    /// Get the current playlist for the active player
    /// - Parameters:
    ///   - host: The current ``HostItem``
    ///   - media: The kind of ``Library/Media``
    func getCurrentPlaylist(host: HostItem, media: Library.Media) async {
        if host.libraryContent.contains(media) {
            await task.getCurrentPlaylist.submit { [self] in
                switch media {
                case .none:
                    if host.media == .audio || host.media == .all {
                        await player.setAudioPlaylist(playlist: await Playlist.getItems(host: host, playlistID: .audio) ?? [])
                    }
                    /// Always get the video playlist because of Music Videos
                    await player.setVideoPlaylist(playlist: await Playlist.getItems(host: host, playlistID: .video) ?? [])
                case .movie:
                    await player.setVideoPlaylist(playlist: await Playlist.getItems(host: host, playlistID: .video) ?? [])
                case .episode:
                    await player.setVideoPlaylist(playlist: await Playlist.getItems(host: host, playlistID: .video) ?? [])
                case .musicVideo:
                    await player.setVideoPlaylist(playlist: await Playlist.getItems(host: host, playlistID: .video) ?? [])
                case .song:
                    await player.setAudioPlaylist(playlist: await Playlist.getItems(host: host, playlistID: .audio) ?? [])
                default:
                    break
                }
                await player.setPlaylistUpdate()
            }
        }
    }
}
