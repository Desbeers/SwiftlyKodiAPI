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
                        await kodi.connectToHost(kodiHost: HostItem(ip: "192.168.11.200", media: .all))
                    }
                }
        }
    }
}

/// PlayerView
struct PlayerView2: View {
    init(item: any LibraryItem) {
        self.item = item
    }
    
    @EnvironmentObject var kodi: KodiConnector
    let item: any LibraryItem
    
    public var body: some View {
        Text(item.media.rawValue)
        Text(item.file)
        //VideoPlayer(player: AVPlayer(url:  URL(string: Files.getFullPath(file: item.file, type: .file))!))
    }
}
