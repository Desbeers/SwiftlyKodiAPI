//
//  KodiConnector+hostSelector.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
import SwiftUI

extension KodiConnector {

    public var hostSelector: some View {
        HostSelector(kodi: self)
    }

    struct HostSelector: View {
        @Bindable var kodi: KodiConnector
        var body: some View {
            if kodi.hostIsOnline(kodi.host) {
                Button(
                    action: {
                        Task {
                            await kodi.loadLibrary(cache: false)
                        }
                    },
                    label: {
                        Label("Reload \(kodi.host.name)", systemImage: "arrow.clockwise")
                    }
                )
                Divider()
            }
            ForEach(kodi.configuredHosts) { host in
                Button(
                    action: {
                        kodi.connect(host: host)
                    },
                    label: {
                        Label("\(host.name)\(kodi.hostIsOnline(host) ? "" : " (offline)")", systemImage: "globe")
                    }
                )
                .disabled(!kodi.hostIsOnline(host) || kodi.host == host)
            }
            if kodi.configuredHosts.isEmpty {
                Button(action: {
                    //
                }, label: {
                    Text("Add a new host")
                })
            }
        }
    }
}
