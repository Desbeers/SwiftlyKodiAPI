//
//  KodiHostItemView.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import SwiftUI

/// SwiftUI View to edit or delete a ``HostItem``
public struct KodiHostItemView: View {
    /// The ``HostItem``
    let host: HostItem
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// The values of the form
    @State private var values: HostItem
    /// The namespace of the View
    @Namespace var mainNamespace
    /// Init the struct
    public init(host: HostItem) {
        self.host = host
        _values = State(initialValue: self.host)
    }
    /// The body of the View
    public var body: some View {
        VStack {
            values.label
                .font(.largeTitle)
            Text(values.ip)
                .padding(.bottom)
            form
                .disabled(!host.isOnline)
            HStack {
                Button(action: {
                    /// Save the settings
                    saveSettings()
                    /// Connect to the host
                    kodi.connect(host: values)
                }, label: {
                    Text("Connect to host")
                })
#if !os(iOS)
                .prefersDefaultFocus(in: mainNamespace)
#endif
                .disabled(validateForm())
                if values.status == .configured {
                    Button(action: {
                        forgetHost()
                    }, label: {
                        Text("Forget '\(values.name)'")
                    })
                }
            }
            .buttonStyle(.borderedProminent)
            if !host.isOnline {
                Text("'\(values.name)' is offline")
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding()
            }
        }
#if !os(iOS)
        .focusScope(mainNamespace)
#endif
        .animation(.default, value: values.ip)
        .task(id: host) {
            if let bonjour = host.bonjour {
                values = HostItem(name: bonjour.name,
                                  ip: bonjour.ip,
                                  port: host.port,
                                  username: host.username,
                                  password: host.password,
                                  media: host.media,
                                  status: host.status
                )
            } else {
                values = host
            }
        }
    }

    public var form: some View {
        Grid(alignment: .center, horizontalSpacing: 10, verticalSpacing: 10) {
            GridRow {
                label(text: "Port")
                    .gridColumnAlignment(.trailing)
                TextField("Port", value: $values.port, formatter: NumberFormatter(), prompt: Text("Webserver port"))
                    .gridColumnAlignment(.leading)
            }
            #if os(tvOS)
            .keyboardType(.numberPad)
            #endif
            footer(text: "The port of the webserver", type: values.port.description.isEmpty ? .error : .valid)
            GridRow {
                label(text: "Username")
                TextField("Username", text: $values.username, prompt: Text("Username"))
            }
            footer(text: "Your username", type: values.username.isEmpty ? .error : .valid)
            GridRow {
                label(text: "Password")
                SecureField("Password", text: $values.password, prompt: Text("Password"))
            }
            footer(text: "Your password", type: values.password.isEmpty ? .error : .valid)
        }
    }

    /// The label for a form item
    /// - Parameter text: The text to display
    /// - Returns: A Text View
    func label(text: String) -> some View {
        Text("\(text):")
    }

    /// The text underneath a form item
    /// - Parameter text: The text to display
    /// - Returns: A Text View
    func footer(text: String, type: FooterType = .valid) -> some View {
        GridRow {
            Color.clear.gridCellUnsizedAxes([.horizontal, .vertical])
            Text(type == .valid ? text : "\(text) (required)")
                .font(.caption)
                .foregroundColor(type == .valid ? .primary : .red)
                .padding(.bottom)
        }
    }
    /// The type of footer
    enum FooterType {
        /// The input is valid
        case valid
        /// The input is not correct
        case error
    }

    func saveSettings() {

        switch host.status {

        case .new:
            values.status = .configured
            kodi.configuredHosts.append(values)
        case .configured:
            if let index = kodi.configuredHosts.firstIndex(where: {$0.ip == host.ip}) {
                kodi.configuredHosts[index] = host
            }
        }
        HostItem.saveConfiguredHosts(hosts: kodi.configuredHosts)
    }

    func forgetHost() {
        if let index = kodi.configuredHosts.firstIndex(where: {$0.ip == host.ip}) {
            kodi.configuredHosts.remove(at: index)
            HostItem.saveConfiguredHosts(hosts: kodi.configuredHosts)
            /// If this host is selected, delete it
            if kodi.host.ip == host.ip {
                kodi.host = HostItem()
                kodi.setState(.none)
                do {
                    try Cache.delete(key: "SelectedHost", root: true)
                } catch {
                    logger("Error deleting selected host")
                }
            }
        }
    }

    func validateForm() -> Bool {
        return values.port.description.isEmpty || values.username.isEmpty || values.password.isEmpty || !host.isOnline
    }
}

public extension KodiHostItemView {

    struct KodiSettings: View {
        public init() {}
        public var body: some View {
            VStack {
                messageHeader(header: "Kodi Settings")
                Text("""
                To have remote access, you need the following settings on the host

                **Settings → Services → General**
                - Announce services to other systems → ON

                *The 'Device name' you set here will be the name of the connection*

                **Settings → Services → Control**
                - Allow programs on other systems to control Kodi → ON
                - Allow control of Kodi via HTTP → ON

                *A 'Username' and 'Password' is required*
                """)
            }
        }
    }
}

public extension KodiHostItemView {

    struct NoHostSelected: View {
        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector
        /// The message
        private var message: String
        /// Init the struct
        public init() {

            if KodiConnector.shared.configuredHosts.isEmpty {
                self.message = "You can add a Kodi that is found on your network."
            } else {
                var content = "You can select a configured host"
                if !KodiConnector.shared.bonjourHosts.filter({$0.new}).isEmpty {
                    content += " or add a new host that is found on your network"
                }
                self.message = "\(content)."
            }
        }
        public var body: some View {
            VStack {
                messageHeader(header: "No Kodi \(kodi.configuredHosts.isEmpty ? "configured" : "selected")")
                if kodi.bonjourHosts.isEmpty {
                    Text("There seems to be no Kodi running on your network")
                } else {
                    Text(message)
                }
            }
        }
    }
}

public extension KodiHostItemView {

    struct HostIsOffline: View {
        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector
        /// The message
        private var message: String
        /// Init the struct
        public init() {

            var content = "There are no other configured Kodi's online."
            if !KodiConnector.shared.configuredHosts.filter({$0.isOnline}).isEmpty {
                content = "You can select another configured Kodi."
            }
            if !KodiConnector.shared.bonjourHosts.filter({$0.new}).isEmpty {
                content += "\n\nThere is another Kodi available on your network."
            }
            self.message = content
        }
        public var body: some View {
            VStack {
                messageHeader(header: "\(kodi.host.name) is offline")
                if kodi.bonjourHosts.isEmpty {
                    Text("There are no Kodi's on your network available.")
                } else {
                    Text(message)
                }
            }
        }
    }
}

extension KodiHostItemView {

    static func messageHeader(header: String) -> some View {
        Text(header)
            .font(.title)
            .padding()
            .minimumScaleFactor(0.2)
            .lineLimit(1)

    }
}
