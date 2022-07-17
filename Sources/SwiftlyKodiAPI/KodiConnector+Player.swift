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
            
            /// Keep an eye on the player if it is streaming
            if currentItem?.media == .stream {
                Task {
                    logger("Check stream")
                    try await Task.sleep(nanoseconds: 5_000_000_000)
                    await getPlayerState()
                }
            }
            
        } else {
            logger("Player is not playing")
            currentItem = nil
        }
        player = properties
    }
}
