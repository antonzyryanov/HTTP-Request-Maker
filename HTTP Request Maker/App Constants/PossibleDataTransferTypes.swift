//
//  PossibleDataTransferTypes.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 17.06.2025.
//

import Foundation

enum PossibleDataTransferTypes: String, CaseIterable {
    case Null = "Null"
    case String = "String"
    case Int = "Int"
    case JSON = "JSON-object"
    case JSONArray = "JSON-array"
    
    init?(id : Int) {
            switch id {
            case 1: self = .Null
            case 2: self = .String
            case 3: self = .Int
            case 4: self = .JSON
            case 5: self = .JSONArray
            default: return nil
        }
    }
    
    static var allTypes: [String] {
        return PossibleDataTransferTypes.allCases.map { $0.rawValue }
    }
    
}
