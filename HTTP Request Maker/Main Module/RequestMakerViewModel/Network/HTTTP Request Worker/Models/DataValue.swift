//
//  DataValue.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 18.06.2025.
//

import Foundation

enum DataValue: Codable {
    case null
    case string(String)
    case int(Int)
    case jsonArray([AnyCodable])
    case jsonObject([String: AnyCodable])

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self = .null
            return
        }

        if let str = try? container.decode(String.self) {
            self = .string(str)
            return
        }

        if let intVal = try? container.decode(Int.self) {
            self = .int(intVal)
            return
        }

        if let arr = try? container.decode([AnyCodable].self) {
            self = .jsonArray(arr)
            return
        }

        if let dict = try? container.decode([String: AnyCodable].self) {
            self = .jsonObject(dict)
            return
        }

        throw DecodingError.typeMismatch(DataValue.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Cannot decode DataValue"))
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .null:
            try container.encodeNil()
        case .string(let str):
            try container.encode(str)
        case .int(let intVal):
            try container.encode(intVal)
        case .jsonArray(let arr):
            try container.encode(arr)
        case .jsonObject(let dict):
            try container.encode(dict)
        }
    }
}
