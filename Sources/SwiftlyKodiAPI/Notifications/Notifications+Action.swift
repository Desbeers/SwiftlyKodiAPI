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

        case .audioLibraryOnUpdate, .videoLibraryOnUpdate:
            getLibraryUpdate(itemID: notification.itemID, media: notification.media)
            await getCurrentPlaylist()
        case .playlistOnAdd, .playlistOnClear:
            await getCurrentPlaylist()
            //break
        case .applicationOnVolumeChanged:
            Task { @MainActor in
                properties = await Application.getProperties()
            }
        default:
            //logger("Default actions after notification")
            await getPlayerState()
            await getCurrentPlaylist()
        }
    }
}
