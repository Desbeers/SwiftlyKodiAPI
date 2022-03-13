//
//  File.swift
//  
//
//  Created by Nick Berendsen on 12/03/2022.
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
            break
        }
    }
}
