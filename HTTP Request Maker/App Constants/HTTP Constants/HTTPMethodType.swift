//
//  HTTPRequestType.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 16.06.2025.
//

import Foundation

enum HTTPMethodType: String, CaseIterable {
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
    
    init?(id : Int) {
            switch id {
            case 1: self = .GET
            case 2: self = .POST
            case 3: self = .PUT
            case 4: self = .PATCH
            case 5: self = .DELETE
            default: return nil
        }
    }
    
    static var allTypes: [String] {
        return HTTPMethodType.allCases.map { $0.rawValue }
    }
    
}

