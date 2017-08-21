//
//  CodableDictionaryValueType.swift
//  MEGameTracker
//
//  Copyright © 2017 Emily Ivie.
//
//  Licensed under The MIT License
//  For full copyright and license information, please see http://opensource.org/licenses/MIT
//  Redistributions of files must retain the above copyright notice.


import Foundation

/// A wrapper for the permitted Codable value types.
/// Permits generic dictionary encoding/decoding when used with CodableDictionary.
public enum CodableDictionaryValueType: Codable {
    case date(Date)
    case uuid(UUID)
    case int(Int)
    case float(Float)
    case bool(Bool)
    case string(String)
    indirect case dictionary(CodableDictionary)
    case empty

    public init(_ value: Any?) {
        self = {
            if let value = value as? Date {
                return .date(value)
            } else if let value = value as? UUID {
                return .uuid(value)
            } else if let value = value as? Int {
                return .int(value)
            } else if let value = value as? Float {
                return .float(value)
            } else if let value = value as? Bool {
                return .bool(value)
            } else if let value = value as? String {
                return .string(value)
            } else if let value = value as? CodableDictionary {
                return .dictionary(value)
            } else {
                return .empty
            }
        }()
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = {
            if let value = try? container.decode(CodableDictionary.self) {
                return .dictionary(value)
            } else if let value = try? container.decode(Date.self) {
                return .date(value)
            } else if let value = try? container.decode(UUID.self) {
                return .uuid(value)
            } else if let value = try? container.decode(Int.self) {
                return .int(value)
            } else if let value = try? container.decode(Float.self) {
                return .float(value)
            } else if let value = try? container.decode(Bool.self) {
                return .bool(value)
            } else if let value = try? container.decode(String.self) {
                return .string(value)
            } else {
                return .empty
            }
        }()
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
            case .date(let value): try container.encode(value)
            case .uuid(let value): try container.encode(value)
            case .int(let value): try container.encode(value)
            case .float(let value): try container.encode(value)
            case .bool(let value): try container.encode(value)
            case .string(let value): try container.encode(value)
            case .dictionary(let value): try container.encode(value)
            default: try container.encodeNil()
        }
    }

    public var value: Any? {
        switch self {
            case .date(let value): return value
            case .uuid(let value): return value
            case .int(let value): return value
            case .float(let value): return value
            case .bool(let value): return value
            case .string(let value): return value
            case .dictionary(let value): return value
            default: return nil
        }
    }
}
extension CodableDictionaryValueType: CustomDebugStringConvertible {
    public var debugDescription: String { return String(describing: value) }
}
extension CodableDictionaryValueType: CustomStringConvertible {
    public var description: String { return String(describing: value) }
}
