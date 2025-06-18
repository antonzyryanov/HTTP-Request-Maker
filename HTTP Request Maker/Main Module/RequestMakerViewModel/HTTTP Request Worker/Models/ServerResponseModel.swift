//
//  ServerResponseModel.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 17.06.2025.
//

import Foundation

struct ServerResponseModel: Codable {
    let status: Bool
    let message: String?
    let data: DataValue?

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try container.decode(Bool.self, forKey: .status)
        message = try? container.decode(String?.self, forKey: .message)
        data = try DataValue(from: decoder)
    }

    enum CodingKeys: String, CodingKey {
        case status, message, data
    }
}

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

struct AnyCodable: Codable {
    let value: Any

    init(_ value: Any) {
        self.value = value
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if container.decodeNil() {
            self.value = NSNull()
        } else if let boolVal = try? container.decode(Bool.self) {
            self.value = boolVal
        } else if let intVal = try? container.decode(Int.self) {
            self.value = intVal
        } else if let doubleVal = try? container.decode(Double.self) {
            self.value = doubleVal
        } else if let stringVal = try? container.decode(String.self) {
            self.value = stringVal
        } else if let arrayVal = try? container.decode([AnyCodable].self) {
            self.value = arrayVal.map { $0.value }
        } else if let dictVal = try? container.decode([String: AnyCodable].self) {
            var dict: [String: Any] = [:]
            for (k, v) in dictVal {
                dict[k] = v.value
            }
            self.value = dict
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Cannot decode AnyCodable")
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch value {
        case is NSNull:
            try container.encodeNil()
        case let boolVal as Bool:
            try container.encode(boolVal)
        case let intVal as Int:
            try container.encode(intVal)
        case let doubleVal as Double:
            try container.encode(doubleVal)
        case let stringVal as String:
            try container.encode(stringVal)
        case let arrayVal as [Any]:
            try container.encode(arrayVal.map { AnyCodable($0) })
        case let dictVal as [String: Any]:
            try container.encode(dictVal.mapValues { AnyCodable($0) })
        default:
            let context = EncodingError.Context(codingPath: container.codingPath, debugDescription: "Cannot encode value")
            throw EncodingError.invalidValue(value, context)
        }
    }
}
