//
//  Setting+Details+Control.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Setting.Details {

    /// Setting Details Control (Global Kodi Type)
    struct Control: Decodable, Equatable, Sendable {

        /// # Setting.Details.ControlBase

        /// Kodi calls this `type` but that is a reserved word
        public var controlType: Setting.Details.ControlType = .unknown

        public var format: ControlFormat = .unknown

        public var delayed: Bool = false

        /// # Setting.Details.Control*

        var hidden: Bool = false
        var verifyNewValue: Bool = false
        var heading: String = ""
        var multiSelect: Bool = false
        var formatLabel: String = ""
        var formatValue: String = ""
        var popup: Bool = false
        var minimumLabel: String = ""

        /// # Coding keys

        enum CodingKeys: String, CodingKey {
            case controlType = "type"
            case format
            case delayed
            case hidden
            case verifyNewValue = "verifynewvalue"
            case heading
            case multiSelect = "multiselect"
            case formatLabel = "formatlabel"
            case formatValue = "formatvalue"
            case popup
            case minimumLabel = "minimumlabel"
            /// The container containing the values
            case control
        }
    }
}

extension Setting.Details.Control {

    /// Custom decoder
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

        if let control = try? container.nestedContainer(keyedBy: CodingKeys.self, forKey: .control) {

            /// # Setting.Details.ControlBase

            self.controlType = try control.decode(Setting.Details.ControlType.self, forKey: .controlType)
            self.format = try control.decode(Setting.Details.ControlFormat.self, forKey: .format)
            self.delayed = try control.decode(Bool.self, forKey: .delayed)

            /// # Setting.Details.Control*

            self.hidden = try control.decodeIfPresent(Bool.self, forKey: .hidden) ?? false
            self.verifyNewValue = try control.decodeIfPresent(Bool.self, forKey: .verifyNewValue) ?? false
            self.heading = try control.decodeIfPresent(String.self, forKey: .heading) ?? ""
            self.multiSelect = try control.decodeIfPresent(Bool.self, forKey: .multiSelect) ?? false
            self.formatLabel = try control.decodeIfPresent(String.self, forKey: .formatLabel) ?? ""
            self.formatValue = try control.decodeIfPresent(String.self, forKey: .formatValue) ?? ""
            self.minimumLabel = try control.decodeIfPresent(String.self, forKey: .minimumLabel) ?? ""
            self.popup = try control.decodeIfPresent(Bool.self, forKey: .popup) ?? false
        }
    }
}
