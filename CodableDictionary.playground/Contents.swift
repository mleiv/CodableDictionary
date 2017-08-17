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
    }
    var genericList: CodableDictionary
    init(genericList: [String: Any?]) {
        self.genericList = CodableDictionary(genericList)
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        genericList = try container.decodeIfPresent(CodableDictionary.self, forKey: .genericList) ?? CodableDictionary()
    }
    // encode not required
}

// source data
let uuid = UUID()
let json = """
    {
        "genericList": {
            "uuid": "\(uuid)"
        }
    }
"""
let minifiedJson = json.replacingOccurrences(of: "\\s", with: "", options: .regularExpression)

// decode
let decodeList = try JSONDecoder().decode(CodableStruct.self, from: minifiedJson.data(using: .utf8)!)
decodeList.genericList["uuid"].value is UUID

// encode
var encodeList = CodableStruct(genericList: ["uuid": uuid])
String(data: try JSONEncoder().encode(encodeList), encoding: .utf8) == minifiedJson

