//
//  MacodiApp.swift
//  Macodi
//
//  Created by Nick Berendsen on 03/07/2022.
//

import SwiftUI
import SwiftlyKodiAPI

@main
struct MacodiApp: App {
    /// The KodiConnector model
    @StateObject var kodi: KodiConnector  = .shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                //.frame(width: 600, height: 600)
                .environmentObject(kodi)
                .task {
                    if kodi.loadingState == .start {
                        await kodi.connectToHost(kodiHost: HostItem(ip: "192.168.11.200", media: .video))
                    }
                }
        }
    }
}
