//  CodableDictionary
//  Allows for the encoding/decoding of dictionaries of varying types and unknown keys
//  (something Codable is currently missing versus the older JSONSerialization)

//  Created by Emily Ivie on 8/16/17.
//  Licensed under The MIT License
//  For full copyright and license information, please see http://opensource.org/licenses/MIT
//  Redistributions of files must retain the above copyright notice.

import Foundation

// example object
struct CodableStruct: Codable {
    enum CodingKeys: String, CodingKey {
        case genericList
        case isBoolean
    }
    var genericList: CodableDictionary
    var isBoolean: Bool?
    init(genericList: [String: Any?]) {
        self.genericList = CodableDictionary(genericList)
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        genericList = try container.decodeIfPresent(CodableDictionary.self, forKey: .genericList) ?? CodableDictionary()
        isBoolean = try container.decodeIfPresent(Bool.self, forKey: .isBoolean)
    }
    // encode not required
}

// source data
let uuid1 = UUID()
let uuid2 = UUID()
let json = """
    {
        "isBoolean": true,
        "genericList": {
            "uuid1": "\(uuid1)",
            "sublist": {
                "uuid2": "\(uuid2)"
            },
            "sublist2": [1, 2]
        }
    }
"""
let minifiedJson = json.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)

// decode
let decodeList = try JSONDecoder().decode(CodableStruct.self, from: minifiedJson.data(using: .utf8)!)
print(decodeList.genericList.dictionary)
(decodeList.genericList["sublist"] as? CodableDictionary)?["uuid2"] is UUID
// encode
var encodeList = CodableStruct(genericList: ["uuid1": uuid1])
encodeList.isBoolean = true
encodeList.genericList["sublist"] = CodableDictionary(["uuid2": uuid2]) // nested dictionaries MUST be CodableDictionary
encodeList.genericList["sublist2"] = [CodableDictionaryValueType(1), CodableDictionaryValueType(2)] // nested arrays MUST be [CodableDictionaryValueType]
String(data: try JSONEncoder().encode(encodeList), encoding: .utf8) == minifiedJson

// boolean must be boolean, not int
let json2 = """
    {
        "isBoolean": 1,
        "genericList": {}
    }
"""
let minifiedJson2 = json2.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)
let decodeList2 = try JSONDecoder().decode(CodableStruct.self, from: minifiedJson2.data(using: .utf8)!)


