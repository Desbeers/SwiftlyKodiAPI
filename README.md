# ``SwiftlyKodiAPI``

A Swift version to access Kodi's JSON-RPC API.

## Overview

*JSON-RPC is a HTTP- and/or raw TCP socket-based interface for communicating with [Kodi](https://kodi.tv).*

This is a framework with a Swift Class that provides structs and functions for easy use of this interface.

It supports version 12 of the interface and that is the stable version of Kodi's JSON-RPC API and is published with the release of v19 (Matrix).

## Limitations

It is currently very much work in progress. I'm going to use this package in my Kodi Music Remote application [Kodio](https://github.com/Desbeers/Kodio). 

## Namespaces and Globl Types

This package tries to follow Kodi's namespaces and global types as much as possible.

See the [Kodi JSON-RPC API](https://kodi.wiki/view/JSON-RPC_API/v12).

## Example

### The Scene

```swift
struct KodioApp: App {
    /// The KodiConnector model
    @StateObject var kodi: KodiConnector  = .shared
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(kodi)
                .task {
                    if kodi.state == .none {
                        await kodi.connectToHost(kodiHost: HostItem(ip: "192.168.11.200", media: .video))
                    }
                }
        }
    }
}
```

### List all TV shows

```swift
import SwiftUI
import SwiftlyKodiAPI

struct ContentView: View {
    /// The KodiConnector
    @EnvironmentObject var kodi: KodiConnector
    /// The list of TV shows
    @State var tvshows: [KodiItem] = []
    /// The body of this View
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 0) {
                ForEach(tvshows) { tvshow in
                    KodiArt.Poster(item: tvshow)
                        .frame(width: 300, height: 450)
                }
            }
        }
        .task(id: kodi.library.tvshows) {
            tvshows = kodi.library.tvshows
        }
    }
}
```
