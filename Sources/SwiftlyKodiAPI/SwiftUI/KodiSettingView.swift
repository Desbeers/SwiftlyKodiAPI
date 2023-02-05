//
//  KodiSettingView.swift
//  SwiftlyKodiAPI
//
//  © 2023 Nick Berendsen
//

import SwiftUI

// MARK: Kodi Setting View

/// SwiftUI View for a ``Setting/Details/KodiSetting``
///
/// - It needs the ``KodiConnector`` in the environment
/// - For tvOS, the View must be in a `NavigationStack`
public struct KodiSettingView: View {
    /// The Kodi setting
    let setting: Setting.Details.KodiSetting
    /// The KodiConnector model
    @EnvironmentObject var kodi: KodiConnector
    /// init: we don't get it for free
    public init(setting: Setting.Details.KodiSetting) {
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
            case .bool:
                BoolSetting(setting: setting)
            case .string:
                StringSetting(setting: setting)
            case .int:
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
            ForEach(kodi.settings.filter({$0.parent == setting.id && $0.enabled})) { child in
                KodiSettingView(setting: child)
            }
        }
#if os(tvOS)
        .padding()
        .buttonStyle(.bordered)
        .pickerStyle(.navigationLink)
#endif
        .padding(setting.parent == .none ? [.top, .horizontal] : .horizontal)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.thickMaterial)
        .cornerRadius(10)
        .animation(.default, value: kodi.settings)
    }
}

// MARK: Bool setting

extension KodiSettingView {

    /// SwiftUI View for a Bool setting
    struct BoolSetting: View {
        /// The KodiConnector model
        @EnvironmentObject var kodi: KodiConnector
        /// The setting
        let setting: Setting.Details.KodiSetting
        /// The state of the setting
        @State private var state: Bool
        /// init: we don't get it for free
        init(setting: Setting.Details.KodiSetting) {
            self.setting = setting
            _state = State(initialValue: setting.settingBool?.value ?? false)
        }
        /// The body of the View
        var body: some View {
            Toggle(setting.base.label, isOn: $state)
                .onChange(of: state) { _ in
                    Task { @MainActor in
                        print("valueBool")
                        await Settings.setSettingValue(setting: setting.id, bool: state)
                        /// Get the settings of the host
                        kodi.settings = await Settings.getSettings()
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
        @EnvironmentObject var kodi: KodiConnector
        /// The setting
        let setting: Setting.Details.KodiSetting
        /// The value of the setting
        @State private var value: String
        /// init: we don't get it for free
        public init(setting: Setting.Details.KodiSetting) {
            self.setting = setting
            _value = State(initialValue: setting.settingString?.value ?? "")
        }
        /// The body of the View
        var body: some View {
            content
                .onChange(of: value) { _ in
                    Task { @MainActor in
                        await Settings.setSettingValue(setting: setting.id, string: value)
                        /// Get the settings of the host
                        kodi.settings = await Settings.getSettings()
                    }
                }
        }
        @ViewBuilder var content: some View {
            switch setting.control.controlType {
            case .list:
                if let options = setting.settingString?.options {
                    Picker(setting.base.label, selection: $value) {
                        ForEach(options, id: \.self) { option in
                            Text(option.label)
                                .tag(option.value)
                        }
                    }
                    .labelsHidden()
                }
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
        @EnvironmentObject var kodi: KodiConnector
        /// The setting
        let setting: Setting.Details.KodiSetting

        let minimum: Int
        let maximum: Int
        let step: Int
        let options: [Setting.Details.Option]

        @State var value: Int

        /// init: we don't get it for free
        public init(setting: Setting.Details.KodiSetting) {
            self.setting = setting
            _value = State(initialValue: setting.settingInt?.value ?? 0)
            minimum = setting.settingInt?.minimum ?? 0
            maximum = setting.settingInt?.maximum ?? 0
            step = setting.settingInt?.step ?? 1
            options = setting.settingInt?.options ?? []
        }

        @State private var state: Bool = false

        var body: some View {
            picker
                .onChange(of: value) { _ in
                    Task { @MainActor in
                        print("valueBool")
                        await Settings.setSettingValue(setting: setting.id, int: value)
                        /// Get the settings of the host
                        kodi.settings = await Settings.getSettings()
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
        @EnvironmentObject var kodi: KodiConnector
        /// The setting
        let setting: Setting.Details.KodiSetting

        let options: [Setting.Details.SettingAddon.Option]

        @State var value: String

        /// init: we don't get it for free
        public init(setting: Setting.Details.KodiSetting) {
            self.setting = setting
            _value = State(initialValue: setting.settingAddon?.value ?? "")
            options = setting.settingAddon?.options ?? []
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
            .onChange(of: value) { _ in
                Task { @MainActor in
                    print("valueString")
                    await Settings.setSettingValue(setting: setting.id, string: value)
                    /// Get the settings of the host
                    kodi.settings = await Settings.getSettings()
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
        @EnvironmentObject var kodi: KodiConnector
        /// The setting
        let setting: Setting.Details.KodiSetting
        /// The options
        @State var options: [Option]
        /// Init: we don't get it for free
        public init(setting: Setting.Details.KodiSetting) {
            self.setting = setting
            let value = setting.settingList?.value ?? []
            let allOptions = setting.settingList?.options ?? []
            var options: [Option] = []
            for option in allOptions {
                options.append(Option(id: option.value,
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
            .onChange(of: options) { _ in
                Task { @MainActor in
                    /// Grab the enabled items
                    let result = options.filter({$0.isSelected}).map(\.id)
                    /// Update the setting
                    await Settings.setSettingValue(setting: setting.id, list: result)
                    /// Get the settings of the host
                    kodi.settings = await Settings.getSettings()
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

    /// ViewBuilder for a specific setting by its ID
    /// - Parameter setting: The ``Setting/ID``
    /// - Returns: A SwiftUI View with the setting
    @ViewBuilder public static func setting(for setting: Setting.Details.KodiSetting.ID) -> some View {
        if let result = KodiConnector.shared.settings.first(where: {$0.id == setting}) {
            KodiSettingView(setting: result)
                .padding(.bottom)
        }
    }
}
