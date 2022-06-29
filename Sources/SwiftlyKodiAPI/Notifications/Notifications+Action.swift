//
//  Notifications+Action.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

extension KodiConnector {

    /// Perform an action after recieving a notification from the Kodi host
    /// - Parameter notification: The received notification
    func notificationAction(notification: Notifications.Item) async {
        switch notification.method {
        case .playerOnAVStart, .playerOnPropertyChanged, .playerOnSpeedChanged, .playerOnStop, .playerOnPause, .playerOnResume:
            await getPlayerState()
        case .audioLibraryOnUpdate, .videoLibraryOnUpdate:
            getMediaItemDetails(itemID: notification.itemID, type: notification.media)
        default:
            logger("No action after notification")
        }
    }
}
