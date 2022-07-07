//
//  KodiConnector+Player.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {
    
    /// Get the first active player ID
    /// - Returns: The active  `playerID`, if any, else `nil`
    public func getPlayerID() async -> Player.ID? {
        if let players = await Player.getActivePlayers(),
           let activePlayer = players.first {
            return activePlayer
        }
        return nil
    }
    
    /// Get the state of the player
    @MainActor func getPlayerState() async {
        /// Defaults
        var properties = Player.Property.Value()
        /// Check if we have an active player
        if let playerID = await getPlayerID() {
            properties = await Player.getProperties(playerID: playerID)
            currentItem = await Player.getItem(playerID: playerID)
        } else {
            logger("Player is not playing")
            currentItem = nil
        }
        player = properties
    }
}
