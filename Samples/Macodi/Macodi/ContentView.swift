//
//  ContentView.swift
//  Macodi
//
//  Created by Nick Berendsen on 03/07/2022.
//

import SwiftUI
import SwiftlyKodiAPI

struct ContentView: View {
    var body: some View {
        NavigationSplitView {
            SidebarView()
        } detail: {
            MainView()
        }
        .toolbar {
            ToolbarItem {
                MediaButtons.PlayPause()
            }
            ToolbarItem {
                MediaButtons.SetShuffle()
            }
            ToolbarItem {
                MediaButtons.SetRepeat()
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
        }
    }
}
