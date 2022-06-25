//
//  Notifications+Action.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {

    /// Perform an action afte recieving a notification from the Kodi host
    /// - Parameter notification: The received notification
    func notificationAction(notification: NotificationItem) async {
        switch notification.method {
        case .playerOnAVStart, .playerOnPropertyChanged:
            await getPlayerProperties(playerID: notification.playerID)
//            Task {
//                await getPlayerProperties(playerID: notification.playerID)
//            }
        case .audioLibraryOnUpdate, .videoLibraryOnUpdate:
            getMediaItemDetails(itemID: notification.itemID, type: notification.media)
        default:
            logger("No action after notification")
        }
    }
}
