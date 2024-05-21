//
//  KodiConnector+hostsView.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen

import SwiftUI

extension KodiConnector {

    public func hostsView(media: HostItem.Media, player: HostItem.Player) -> some View {
        HostsView(kodi: self, media: media, player: player)
    }

    struct HostsView: View {
        @Bindable var kodi: KodiConnector
        let media: HostItem.Media
        let player: HostItem.Player
        /// The selected host
        @State private var selection: HostItem?
        var body: some View {
            HStack {
                hostList
                hostEdit
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        /// The lists of hosts
        @MainActor var hostList: some View {
            SwiftUI.List(selection: $selection) {
                Section("Your Hosts") {
                    if kodi.configuredHosts.isEmpty {
                        Text("You have no host configured")
                            .fixedSize()
                    } else {
                        ForEach(kodi.configuredHosts) { host in
                            hostItem(host: host)
                        }
                    }
                }
                if let newHosts = kodi.getNewHosts() {
                    Section("New Kodi's on your network") {
                        ForEach(newHosts) { host in
                            let newHost = HostItem(
                                name: host.name,
                                ip: host.ip,
                                port: 8080,
                                tcpPort: host.tcpPort,
                                media: media,
                                player: player,
                                status: .new
                            )
                            hostItem(host: newHost)
                        }
                    }
                }
            }
            #if os(macOS)
            .frame(width: 200)
            .listStyle(.sidebar)
            #elseif os(tvOS)
            .buttonStyle(.card)
            #endif
        }

        /// The View for a Host
        /// - Parameter host: The Kodi `Host`
        /// - Returns: A View with the host information
        func hostItem(host: HostItem) -> some View {
            #if !os(tvOS)
            hostLabel(host: host)
            .tag(host)
            #else
            Button(
                action: {
                    selection = host
                },
                label: {
                    hostLabel(host: host)
                        .padding()
            })
            #endif
        }

        func hostLabel(host: HostItem) -> some View {
            Label(
                title: {
                    VStack(alignment: .leading) {
                        Text(host.name)
                        Text(kodi.hostIsOnline(host) ? "Online" : "Offline")
                            .font(.caption)
                            .opacity(0.6)
                            .padding(.bottom, 2)
                    }
                },
                icon: {
                    Image(systemName: "globe")
                        .foregroundColor(
                            kodi.hostIsOnline(host) ? kodi.hostIsSelected(host) ? .green : host.status == .configured ? .accentColor : .orange : .red
                        )
                }
            )
        }

        /// View for editing a host
        var hostEdit: some View {
            VStack {
                if let selection {
                    KodiHostItemView(host: selection) {
                        self.selection = nil
                    }
                } else {
                    Text("Add or edit your Kodi hosts")
                        .font(.title)
                        .lineLimit(1)
                        .minimumScaleFactor(0.1)
                    KodiHostItemView.KodiSettings()
                        .padding()
                        .background(.thickMaterial)
                        .cornerRadius(10)
                }
            }
            .padding()
            .minimumScaleFactor(0.1)
            .frame(maxHeight: .infinity, alignment: .top)
        }
    }

}
