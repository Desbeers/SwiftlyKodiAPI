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
        NavigationView {
            SidebarView()
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
        }
    }
}
