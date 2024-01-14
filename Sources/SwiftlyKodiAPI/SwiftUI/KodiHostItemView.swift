//
//  KodiHostItemView.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import SwiftUI
import SwiftlyStructCache
import OSLog

// MARK: Kodi HostItem View

/// SwiftUI View to edit or delete a ``HostItem``
public struct KodiHostItemView: View {
    /// The ``HostItem``
    let host: HostItem
    /// The closure action
    let action: () -> Void
    /// The KodiConnector model
    @Environment(KodiConnector.self)
    private var kodi
    /// The values of the form
    @State private var values: HostItem
    /// The namespace of the View
    @Namespace var mainNamespace
    /// Init the struct
    public init(host: HostItem, action: @escaping () -> Void) {
        self.host = host
        _values = State(initialValue: self.host)
        self.action = action
    }
    /// The body of the View
    public var body: some View {
        VStack {
            Label(
                title: {
                    Text(host.name)
                }, icon: {
                    Image(systemName: host.status == .configured ? "globe" : "star.fill")
                }
            )
            .font(.largeTitle)
            Text(values.ip)
                .padding(.bottom)
            form
                .disabled(!kodi.hostIsOnline(host))
            HStack {
                Button(action: {
                    /// Save the host
                    saveHost()
                    /// Connect to the host
                    kodi.connect(host: values)
                    /// Do the action
                    action()
                }, label: {
                    Text("Connect to host")
                })
#if os(macOS) || os(tvOS)
                .prefersDefaultFocus(in: mainNamespace)
#endif
                .disabled(validateForm() || (values == host && kodi.host == values))
                if values.status == .configured {
                    Button(action: {
                        forgetHost()
                        /// Do the action
                        action()
                    }, label: {
                        Text("Forget '\(values.name)'")
                    })
                }
            }
            .buttonStyle(.borderedProminent)
            if !kodi.hostIsOnline(host) {
                Text("'\(values.name)' is offline")
                    .foregroundColor(.red)
                    .font(.caption)
                    .padding()
            }
        }
#if os(macOS) || os(tvOS)
        .focusScope(mainNamespace)
#endif
        .animation(.default, value: values.ip)
        .task(id: host) {
            if let bonjour = kodi.bonjourHosts.first(where: { $0.name == host.name }) {
                values = HostItem(
                    name: bonjour.name,
                    ip: bonjour.ip,
                    port: host.port,
                    tcpPort: bonjour.tcpPort,
                    username: host.username,
                    password: host.password,
                    media: host.media,
                    player: host.player,
                    status: host.status
                )
            } else {
                values = host
            }
        }
    }

    /// The form for the View
    public var form: some View {
        Form {
            LabeledContent("Port:") {
                TextField(value: $values.port, formatter: NumberFormatter()) {}
#if !os(macOS)
                    .keyboardType(.numberPad)
#endif
            }
            footer(text: "The port of the webserver", type: values.port.description.isEmpty ? .error : .valid)
            LabeledContent("Username:") {
                TextField(text: $values.username, prompt: Text("Username")) {}
            }
            footer(text: "Your username", type: values.username.isEmpty ? .error : .valid)
            LabeledContent("Password:") {
                SecureField(text: $values.password, prompt: Text("Password")) {}
            }
            footer(text: "Your password", type: values.password.isEmpty ? .error : .valid)
        }
#if os(macOS)
        .frame(maxWidth: 200)
#elseif os(tvOS)
        .frame(maxWidth: 500)
#elseif os(iOS)
        .frame(maxWidth: 300)
        .textFieldStyle(.roundedBorder)
        .autocapitalization(.none)
        #else
        /// visionOS can't show column style
        .formStyle(.grouped)
        .autocapitalization(.none)
#endif
        .formStyle(.columns)
    }

    /// The text underneath a form item
    /// - Parameter text: The text to display
    /// - Returns: A Text View
    func footer(text: String, type: FooterType = .valid) -> some View {
        Text(type == .valid ? text : "\(text) (required)")
            .font(.caption)
            .foregroundColor(type == .valid ? .primary : .red)
            .padding(.bottom)
    }
    /// The type of footer
    enum FooterType {
        /// The input is valid
        case valid
        /// The input is not correct
        case error
    }

    /// Save the host
    func saveHost() {
        switch host.status {
        case .new:
            values.status = .configured
            kodi.configuredHosts.append(values)
        case .configured:
            if let index = kodi.configuredHosts.firstIndex(where: { $0.ip == host.ip }) {
                kodi.configuredHosts[index] = host
            }
        }
        HostItem.saveConfiguredHosts(hosts: kodi.configuredHosts)
    }

    /// Forget the host
    @MainActor
    func forgetHost() {
        if let index = kodi.configuredHosts.firstIndex(where: { $0.ip == host.ip }) {
            kodi.configuredHosts.remove(at: index)
            HostItem.saveConfiguredHosts(hosts: kodi.configuredHosts)
            /// If this host is selected, delete it
            if kodi.host.ip == host.ip {
                kodi.host = HostItem(ip: "", port: 8080, tcpPort: 9090)
                kodi.setStatus(.none)
                do {
                    try Cache.delete(key: "SelectedHost")
                } catch {
                    Logger.connection.error("Error deleting selected host")
                }
            }
        }
    }

    /// Validate the form
    /// - Returns: True when validaded; else False
    func validateForm() -> Bool {
        return values.port.description.isEmpty || values.username.isEmpty || values.password.isEmpty || !kodi.hostIsOnline(host)
    }
}

// MARK: Messages

public extension KodiHostItemView {

    /// SwiftUI View to show information about Kodi settings
    struct KodiSettings: View {
        public init() {}
        public var body: some View {
            Message(header: "Access your Kodi") {
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

    /// SwiftUI View to show information when no host is selected
    struct NoHostSelected: View {
        /// The KodiConnector model
        @Environment(KodiConnector.self)
        private var kodi
        /// The message
        @State private var message: String = ""
        /// Init the struct
        public init() {}
        /// The body of the `View`
        public var body: some View {
            Message(header: "No Kodi \(kodi.configuredHosts.isEmpty ? "configured" : "selected")") {
                if kodi.bonjourHosts.isEmpty {
                    Text("There seems to be no Kodi running on your network")
                } else {
                    Text(message)
                }
            }
            .task {
                if kodi.configuredHosts.isEmpty {
                    self.message = "You can add a Kodi that is found on your network."
                } else {
                    var content = "You can select a configured host"
                    if !kodi.bonjourHosts.filter({ $0.status == .new }).isEmpty {
                        content += " or add a new host that is found on your network"
                    }
                    self.message = "\(content)."
                }
            }
        }
    }
}

public extension KodiHostItemView {

    /// SwiftUI View to show information when a host is offline
    struct HostIsOffline: View {
        /// The KodiConnector model
        @Environment(KodiConnector.self)
        private var kodi
        /// The message
        @State private var message: String = ""
        /// Init the struct
        public init() {}
        /// The body of the `View`
        public var body: some View {
            Message(header: "\(kodi.host.name) is offline") {
                if kodi.bonjourHosts.isEmpty {
                    Text("There are no Kodi's on your network available")
                } else {
                    Text(message)
                }
            }
            .task {
                var content = "There are no other configured Kodi's online"
                if !kodi.configuredHosts.filter({ kodi.hostIsOnline($0) }).isEmpty {
                    content = "You can select another configured Kodi"
                }
                if !kodi.bonjourHosts.filter({ $0.status == .new }).isEmpty {
                    content += "\n\nThere is another Kodi available on your network"
                }
                self.message = content
            }
        }
    }
}

extension KodiHostItemView {

    struct Message<Content: View>: View {
        let header: String
        @ViewBuilder var content: () -> Content
        public var body: some View {
            VStack {
                Text(header)
                #if os(tvOS)
                    .font(.title3)
                #else
                    .font(.title)
                #endif
                    .padding()
                    .minimumScaleFactor(0.2)
                    .lineLimit(1)
                content()
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            .padding(.bottom)
        }
    }
}
