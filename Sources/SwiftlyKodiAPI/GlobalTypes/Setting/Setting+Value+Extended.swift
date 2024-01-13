//
//  Setting+Value+Extended.swift
//  SwiftlyKodiAPI
//
//  © 2024 Nick Berendsen
//

import Foundation

public extension Setting.Value {

    /// Setting values (Global Kodi Type)
    /// - Note: Used as result for `Settings.GetSettingValue`
    struct Extended: Decodable, Sendable {
        /// Init the struct with empty optionals
        init() {}
        /// The optional `Bool` value of the setting
        public var boolean: Bool?
        /// The optional `Int` value of the setting
        public var integer: Int?
        /// The optional `Double` value of the setting
        public var number: Double?
        /// The optional `[Int]` value of the setting
        public var list: [Int]?
        /// The optional `String` value of the setting
        public var string: String?
        /// The coding keys
        enum CodingKeys: CodingKey {
            case value
        }
        /// Custom decoder
        public init(from decoder: Decoder) throws {

            let container: KeyedDecodingContainer<CodingKeys> = try decoder.container(keyedBy: CodingKeys.self)

            if let result = try? container.decode(Int.self, forKey: .value) {
                self.integer = result
            } else if let result = try? container.decode(Double.self, forKey: .value) {
                self.number = result
            } else if let result = try? container.decode(String.self, forKey: .value) {
                self.string = result
            } else if let result = try? container.decode(Bool.self, forKey: .value) {
                self.boolean = result
            } else if let result = try? container.decode([Int].self, forKey: .value) {
                self.list = result
            }
        }
    }
}
