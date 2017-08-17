//
//  CodableDictionaryValueType.swift
//  MEGameTracker
//
//  Created by Emily Ivie on 8/16/17.
//  Copyright © 2017 Emily Ivie. All rights reserved.
//

import Foundation

/// A wrapper for the permitted Codable value types.
/// Permits generic dictionary encoding/decoding when used with CodableDictionary.
public struct CodableDictionaryValueType {
    public let value: Any?
    public init(_ value: Any?) { self.value = value }
}
extension CodableDictionaryValueType: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = {
            if let value = try? container.decode(Date.self) {
                print("Date-")
                return value
            } else if let value = try? container.decode(UUID.self) {
                print("UUID-")
                return value
            } else if let value = try? container.decode(Int.self) {
                print("Int-")
                return value
            } else if let value = try? container.decode(Float.self) {
                return value
            } else if let value = try? container.decode(Bool.self) {
                return value
            } else if let value = try? container.decode(String.self) {
                print("String-")
                return value
            } else {
                return nil
            }
        }()
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        if let value = value as? Date {
            print("-Date")
            try container.encode(value)
        } else if let value = value as? UUID {
            print("-UUID")
            try container.encode(value)
        } else if let value = value as? Int {
            print("-Int")
            try container.encode(value)
        } else if let value = value as? Float {
            try container.encode(value)
        } else if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? String {
            print("-String")
            try container.encode(value)
        } else {
            try container.encodeNil()
        }
    }
}
extension CodableDictionaryValueType: CustomDebugStringConvertible {
    public var debugDescription: String { return String(describing: value) }
}
extension CodableDictionaryValueType: CustomStringConvertible {
    public var description: String { return String(describing: value) }
}
// Date and UUID missing
//extension CodableDictionaryValueType: ExpressibleByIntegerLiteral {
//    public init(integerLiteral value: Int) { self.value = value }
//}
//extension CodableDictionaryValueType: ExpressibleByFloatLiteral {
//    public init(floatLiteral value: Float) { self.value = value }
//}
//extension CodableDictionaryValueType: ExpressibleByBooleanLiteral {
//    public init(booleanLiteral value: Bool) { self.value = value }
//}
//extension CodableDictionaryValueType: ExpressibleByStringLiteral {
//    public init(stringLiteral value: String) { self.value = value }
//}
//extension CodableDictionaryValueType {
//    public init(_ value: Date) { self.value = value }
//}
