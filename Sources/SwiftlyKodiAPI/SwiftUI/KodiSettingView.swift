//
//  KodiSettingView.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import SwiftUI

// MARK: Kodi Setting View

/// SwiftUI View for a ``Setting/Details/KodiSetting``
///
/// - It needs the ``KodiConnector`` in the environment
/// - For tvOS, the View must be in a `NavigationStack`
public struct KodiSettingView: View {
    /// The Kodi setting
    let setting: Setting.Details.Setting
    /// The KodiConnector model
    @Environment(KodiConnector.self)
    private var kodi
    /// init: we don't get it for free
    public init(setting: Setting.Details.Setting) {
        self.setting = setting
    }
    /// The body of the View
    public var body: some View {
        VStack(alignment: .leading) {
            Text(setting.base.label)
#if os(macOS)
                .font(setting.parent == .none ? .title2 : .headline)
#endif
#if os(tvOS)
                .font(setting.parent == .none ? .headline : .subheadline)
#endif
            switch setting.settingType {
            case .boolean:
                BoolSetting(setting: setting)
            case .string:
                StringSetting(setting: setting)
            case .integer:
                IntSetting(setting: setting)
            case .list:
                ListSetting(setting: setting)
            case .addon:
                AddonSetting(setting: setting)
            default:
                Text("Not implemented")
                    .font(.title)
            }
            Text(setting.base.help)
                .font(.caption)
                .padding(.bottom)
            /// Recursive load child settings
            ForEach(kodi.settings.filter { $0.parent == setting.id && $0.enabled }) { child in
                KodiSettingView(setting: child)
            }
        }
        .modifier(SettingWrapper(setting: setting))
    }
}

// MARK: Bool setting

extension KodiSettingView {

    /// SwiftUI View for a Bool setting
    struct BoolSetting: View {
        /// The KodiConnector model
        @Environment(KodiConnector.self)
        private var kodi
        /// The setting
        let setting: Setting.Details.Setting
        /// The state of the setting
        @State private var state: Bool
        /// init: we don't get it for free
        init(setting: Setting.Details.Setting) {
            self.setting = setting
            _state = State(initialValue: setting.boolean.value)
        }
        /// The body of the View
        var body: some View {
            Toggle(setting.base.label, isOn: $state)
                .onChange(of: state) {
                    Task {
                        await Settings.setSettingValue(host: kodi.host, setting: setting.id, bool: state)
                        /// Get the settings of the host
                        kodi.settings = await Settings.getSettings(host: kodi.host)
                    }
                }
        }
    }
}

// MARK: String setting

extension KodiSettingView {

    /// SwiftUI View for a String setting
    struct StringSetting: View {
        /// The KodiConnector model
        @Environment(KodiConnector.self)
        private var kodi
        /// The setting
        let setting: Setting.Details.Setting
        /// The value of the setting
        @State private var value: String
        /// init: we don't get it for free
        public init(setting: Setting.Details.Setting) {
            self.setting = setting
            _value = State(initialValue: setting.string.value)
        }
        /// The body of the View
        var body: some View {
            content
                .onChange(of: value) {
                    Task {
                        await Settings.setSettingValue(host: kodi.host, setting: setting.id, string: value)
                        /// Get the settings of the host
                        kodi.settings = await Settings.getSettings(host: kodi.host)
                    }
                }
        }
        @ViewBuilder var content: some View {
            switch setting.control.controlType {
            case .list:
                Picker(setting.base.label, selection: $value) {
                    ForEach(setting.string.options, id: \.self) { option in
                        Text(option.label)
                            .tag(option.value)
                    }
                }
                .labelsHidden()
            case .edit:
                TextField(setting.base.label, text: $value)
            default:
                Text("Error: String Setting - \(setting.control.controlType.rawValue)")
            }
        }
    }
}

// MARK: Int setting

extension KodiSettingView {

    /// SwiftUI View for an Int setting
    struct IntSetting: View {
        /// The KodiConnector model
        @Environment(KodiConnector.self)
        private var kodi
        /// The setting
        let setting: Setting.Details.Setting

        let minimum: Int
        let maximum: Int
        let step: Int
        let options: [Setting.Details.SettingInt.Option]

        @State private var value: Int

        /// init: we don't get it for free
        public init(setting: Setting.Details.Setting) {
            self.setting = setting
            _value = State(initialValue: setting.integer.value)
            minimum = setting.integer.minimum
            maximum = setting.integer.maximum
            step = setting.integer.step
            options = setting.integer.options
        }

        @State private var state: Bool = false

        var body: some View {
            picker
                .onChange(of: value) {
                    Task {
                        await Settings.setSettingValue(host: kodi.host, setting: setting.id, int: value)
                        /// Get the settings of the host
                        kodi.settings = await Settings.getSettings(host: kodi.host)
                    }
                }
        }

        @ViewBuilder var picker: some View {
            Picker(setting.base.label, selection: $value) {
                switch setting.control.controlType {
                case .list:
                    ForEach(options, id: \.self) { option in
                        Text(option.label)
                            .tag(option.value)
                    }
                case .spinner:
                    ForEach(Array(stride(from: minimum, to: maximum, by: step)), id: \.self) { value in
                        Text(formatLabel(value: value))
                            .tag(value)
                    }
                default:
                    Text("Error: Int Setting - \(setting.control.controlType.rawValue)")
                }
            }
            .labelsHidden()
        }

        /// Format the Label
        /// - Parameter value: The 'Int' value
        /// - Returns: The 'label' as String
        func formatLabel(value: Int) -> String {
            let labelRegex = #/{0:d}(?<label>.+?)/#
            if let result = setting.control.formatLabel.wholeMatch(of: labelRegex) {
                return "\(value)\(result.label)"
            } else {
                return "\(value)"
            }
        }
    }
}

// MARK: Addon setting

extension KodiSettingView {

    /// SwiftUI View for an Addon setting
    struct AddonSetting: View {
        /// The KodiConnector model
        @Environment(KodiConnector.self)
        private var kodi
        /// The setting
        let setting: Setting.Details.Setting

        let options: [Setting.Details.SettingAddon.Option]

        @State private var value: String

        /// init: we don't get it for free
        public init(setting: Setting.Details.Setting) {
            self.setting = setting
            _value = State(initialValue: setting.addon.value)
            options = setting.addon.options
        }

        @State private var state: Bool = false

        var body: some View {
            Picker(setting.base.label, selection: $value) {
                ForEach(options, id: \.self) { option in
                    Text(option.label)
                        .tag(option.value)
                }
            }
            .labelsHidden()
            .onChange(of: value) {
                Task {
                    await Settings.setSettingValue(host: kodi.host, setting: setting.id, string: value)
                    /// Get the settings of the host
                    kodi.settings = await Settings.getSettings(host: kodi.host)
                }
            }
        }
    }
}

// MARK: List setting

extension KodiSettingView {

    /// SwiftUI View for a List setting
    struct ListSetting: View {
        /// The KodiConnector model
        @Environment(KodiConnector.self)
        private var kodi
        /// The setting
        let setting: Setting.Details.Setting
        /// The options
        @State private var options: [Option]
        /// Init: we don't get it for free
        public init(setting: Setting.Details.Setting) {
            self.setting = setting
            let value = setting.list.value
            let allOptions = setting.list.options
            var options: [Option] = []
            for option in allOptions {
                options.append(Option(
                    id: option.value,
                    label: option.label,
                    isSelected: value.contains(option.value) ? true : false)
                )
            }
            self.options = options
        }
        /// The body of the View
        var body: some View {
            ForEach(options) { option in
                Toggle(option.label, isOn: $options[option.id].isSelected)
            }
            .onChange(of: options) {
                Task {
                    /// Grab the enabled items
                    let result = options.filter { $0.isSelected } .map(\.id)
                    /// Update the setting
                    await Settings.setSettingValue(host: kodi.host, setting: setting.id, list: result)
                    /// Get the settings of the host
                    kodi.settings = await Settings.getSettings(host: kodi.host)
                }
            }
        }
        /// Structure of an option
        struct Option: Identifiable, Equatable {
            var id: Int
            var label: String
            var isSelected: Bool
        }
    }
}

// MARK: View a specific setting by its ID

extension KodiSettingView {

    /// SwiftUI `View` for a specific setting by its ID
    public struct SingleSetting: View {
        public init(setting: Setting.Details.Setting.ID) {
            self.setting = setting
        }
        /// The KodiConnector model
        @Environment(KodiConnector.self)
        private var kodi
        /// The ``Setting/ID``
        private let setting: Setting.Details.Setting.ID
        /// The body of the `View`
        public var body: some View {
            if let result = kodi.settings.first(where: { $0.id == setting }) {
                KodiSettingView(setting: result)
                    .padding(.bottom)
            }
        }
    }
}

extension KodiSettingView {

    /// SwiftUI View for a Waning
    public struct Warning: View {
        /// The KodiConnector model
        @Environment(KodiConnector.self)
        private var kodi
        public init() {}
        public var body: some View {
            Label(
                title: {
                    // swiftlint:disable:next line_length
                    Text("These are the **Kodi** settings on '\(kodi.host.name)', not **Komodio** settings.\n\n**Komodio** will use these settings, however, it will affect all clients, not just **Komodio**.")
                }, icon: {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                }
            )
            .padding(.vertical)
            .modifier(SettingWrapper())
        }
    }
}


// MARK: Setting Wrapper modifier

/// A `ViewModifier` to wrap a setting
struct SettingWrapper: ViewModifier {
    /// The Kodi setting
    var setting: Setting.Details.Setting?
    /// The KodiConnector model
    @Environment(KodiConnector.self)
    private var kodi
    /// The modifier
    func body(content: Content) -> some View {
        content
#if os(tvOS)
        .padding()
        .buttonStyle(.bordered)
        .pickerStyle(.navigationLink)
#endif
        .padding(setting?.parent == Setting.ID.none ? [.top, .horizontal] : .horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thickMaterial)
        .cornerRadius(10)
        .animation(.default, value: kodi.settings)
    }
}
