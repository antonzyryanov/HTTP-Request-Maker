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
        
        data = try container.decode(DataValue.self, forKey: .data)
    }

    enum CodingKeys: String, CodingKey {
        case status, message, data
    }
}
