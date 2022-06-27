//
//  KodiRemoteApp.swift
//  Shared
//
//  Created by Nick Berendsen on 25/06/2022.
//

import SwiftUI
import SwiftlyKodiAPI

@main
struct KodiRemoteApp: App {
    /// The KodiConnector model
    @StateObject var kodi: KodiConnector  = .shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(kodi)
                .task {
                    if kodi.loadingState == .start {
                        await kodi.connectToHost(kodiHost: HostItem(ip: "192.168.11.200", media: .all))
                    }
                }
        }
#if os(macOS)
        .windowStyle(.hiddenTitleBar)
#endif
    }
}
