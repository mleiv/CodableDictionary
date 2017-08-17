//
//  CodableDictionary.swift
//  MEGameTracker
//
//  Created by Emily Ivie on 8/16/17.
//  Copyright © 2017 Emily Ivie. All rights reserved.
//

import Foundation

/// Permits generic dictionary encoding/decoding when used with simple data types
/// (see CodableDictionaryValueType)
///
/// Example:
/// ```Swift
///    struct Test: Codable {
///        enum CodingKeys: String, CodingKey {
///            case genericList
///        }
///        var genericList: CodableDictionary
///        init(genericList: [String: Any?]) {
///            self.genericList = CodableDictionary(genericList)
///        }
///        init(from decoder: Decoder) throws {
///            let container = try decoder.container(keyedBy: CodingKeys.self)
///            genericList = try container.decodeIfPresent(CodableDictionary.self, forKey: .genericList) ?? CodableDictionary()
///        }
///        // encode not required
///    }
///    let json = """
///            { "genericList": { "uuid": "\(UUID())" } }
///        """
///    let decodeList = try JSONDecoder().decode(Test.self, from: json.data(using: .utf8)!)
///    var encodeList = Test(genericList: ["uuid": UUID()])
///    String(data: try JSONEncoder().encode(encodeList), encoding: .utf8)
/// ```
public struct CodableDictionary {
    public typealias Key = String
    public typealias Value = CodableDictionaryValueType
    public typealias DictionaryType = Dictionary<Key, Value>
    private let dictionary: DictionaryType
    public init(_ dictionary: [String: Any?] = [:]) {
        self.dictionary = Dictionary(uniqueKeysWithValues: dictionary.map {
            ($0.0, CodableDictionaryValueType($0.1))
        })
    }
}
extension CodableDictionary: Collection {
    public typealias IndexDistance = DictionaryType.IndexDistance
    public typealias Indices = DictionaryType.Indices
    public typealias Iterator = DictionaryType.Iterator
    public typealias SubSequence = DictionaryType.SubSequence

    public var startIndex: Index { return dictionary.startIndex }
    public var endIndex: DictionaryType.Index { return dictionary.endIndex }
    public subscript(position: Index) -> Iterator.Element { return dictionary[position] }
    public subscript(bounds: Range<Index>) -> SubSequence { return dictionary[bounds] }
    public var indices: Indices { return dictionary.indices }
    public subscript(key: Key) -> Value {
        get { return dictionary[key] ?? CodableDictionaryValueType(nil) }
//        set { dictionary[key] = newValue }
    }
    public func index(after i: Index) -> Index {
        return dictionary.index(after: i)
    }
    public func makeIterator() -> DictionaryIterator<Key, Value> {
        return dictionary.makeIterator()
    }
    public typealias Index = DictionaryType.Index
}
extension CodableDictionary:  ExpressibleByDictionaryLiteral {
    public init(dictionaryLiteral elements: (Key, Value)...) {
        dictionary = DictionaryType(uniqueKeysWithValues: elements)
    }
}
extension CodableDictionary: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        dictionary = try container.decode(DictionaryType.self)
    }
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(dictionary)
    }
}
extension CodableDictionary: CustomDebugStringConvertible {
    public var debugDescription: String { return dictionary.debugDescription }
}
extension CodableDictionary: CustomStringConvertible {
    public var description: String { return dictionary.description }
}
