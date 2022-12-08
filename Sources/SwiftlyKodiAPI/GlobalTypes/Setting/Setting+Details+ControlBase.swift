//
//  Setting+Details+ControlBase.swift
//  SwiftlyKodiAPI
//
//  © 2022 Nick Berendsen
//

import Foundation

public extension Setting.Details {

    /// Control Base details
    struct ControlBase: Decodable {

        /// # Setting.Details.ControlBase

        public var delayed: Bool = false
        public var format: String = ""
        /// Kodi calls this `type` but that is a reserved word
        public var controlType: Setting.Details.ControlType = .list

        /// # Setting.Details.ControlRange + Setting.Details.ControlSpinner

        public var formatLabel: String = ""

        /// # Setting.Details.ControlSpinner

        public var minimumLabel: String = ""

        /// # Coding keys

        enum CodingKeys: String, CodingKey {
            case delayed
            case format
            case formatLabel = "formatlabel"
            case minimumLabel = "minimumlabel"
            case controlType = "type"
        }
    }
}

extension Setting.Details.ControlBase {

    /// Custom decoder
    public init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<Setting.Details.ControlBase.CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

        self.delayed = try container.decode(Bool.self, forKey: CodingKeys.delayed)
        self.format = try container.decode(String.self, forKey: CodingKeys.format)
        self.formatLabel = try container.decodeIfPresent(String.self, forKey: CodingKeys.formatLabel) ?? "{0:d} sec"
        self.minimumLabel = try container.decodeIfPresent(String.self, forKey: CodingKeys.minimumLabel) ?? "Off"
        self.controlType = try container.decode(Setting.Details.ControlType.self, forKey: CodingKeys.controlType)

    }
}
