//
//  Notifications+Action.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {
    
    func notificationAction(notification: NotificationItem) {
        switch notification.method {
        case .playerOnAVStart:
            Task {
                await getPlayerProperties(playerID: notification.playerID)
            }
        case .audioLibraryOnUpdate, .videoLibraryOnUpdate:
            updateMediaItemDetails(itemID: notification.itemID, type: notification.media)
        default:
            logger("No action after notification")
        }
    }
}
