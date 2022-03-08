# ``SwiftlyKodiAPI``

A Swift version to access Kodi's JSON-RPC API.

## Overview

*JSON-RPC is a HTTP- and/or raw TCP socket-based interface for communicating with [Kodi](https://kodi.tv).*

This is a framework with a Swift Class that provides structs and functions for easy use of this interface.

It supports version 12 of the interface and that is the stable version of Kodi's JSON-RPC API and is published with the release of v19 (Matrix).

## Limitations

It is currently very much work in progress. I'm going to use this package in my Kodi Music Remote application [Kodio](https://github.com/Desbeers/Kodio). 

## Example

### The Scene

```swift
import SwiftUI
import SwiftlyKodiAPI

@main
struct VideoPlayerApp: App {
    /// The KodiConnector model
    @StateObject var kodi: KodiConnector  = .shared
    /// The Scene
    var body: some Scene {
        WindowGroup {
            Group {
                if kodi.library.isEmpty {
                    VStack {
                        Text("Loading your library")
                            .font(.title)
                        ProgressView()
                    }
                } else {
                    ContentView()
                        .environmentObject(kodi)
                }
            }
            .task {
                await kodi.connectToHost(kodiHost: HostItem(ip: "127.0.0.1"))
            }
        }
    }
}
```

### List all TV shows containing 'Comedy' genre

```swift
import SwiftUI
import SwiftlyKodiAPI

struct ContentView: View {
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The list of TV shows
    @State var tvshows: [KodiItem] = []
    /// The View
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(tvshows) { tvshow in
                    KodiItemView(item: tvshow)
                }
            }
        }
        .task {
            let filter = MediaFilter(media: .tvshow, genre: "Comedy")
            tvshows =  kodi.media.filter(filter)
        }
    }
}
```
