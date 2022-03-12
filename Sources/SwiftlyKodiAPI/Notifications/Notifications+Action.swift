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
        default:
            break
        }
    }
}
