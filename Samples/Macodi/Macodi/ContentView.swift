//
//  ContentView.swift
//  Macodi
//
//  Created by Nick Berendsen on 03/07/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct ContentView: View {
    
    @State private var columnVisibility = NavigationSplitViewVisibility.all
    
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            SidebarView()
                .navigationSplitViewColumnWidth(240)
        } detail: {
            MainView()
        }
        .toolbar {
            ToolbarItem {
                MediaButtons.PlayPrevious()
            }
            ToolbarItem {
                MediaButtons.PlayPause()
            }
            ToolbarItem {
                MediaButtons.PlayNext()
            }
            ToolbarItem {
                MediaButtons.SetShuffle()
            }
            ToolbarItem {
                MediaButtons.SetRepeat()
            }
            ToolbarItem {
                MediaButtons.SetPartyMode()
            }
            ToolbarItem {
                Button(action: {
                    Task {
                        await KodiConnector.shared.reloadHost()
                    }
                }, label: {
                    Text("Reload library")
                })
            }
            ToolbarItem {
                Button(action: {
                    Task {
                        await KodiConnector.shared.updateLibrary()
                    }
                }, label: {
                    Text("Update library")
                })
            }
            ToolbarItem {
                Button(action: {
                    Task {
                        await KodiConnector.shared.getCurrentPlaylist()
                    }
                }, label: {
                    Text("Get playlist")
                })
            }
        }
    }
}
