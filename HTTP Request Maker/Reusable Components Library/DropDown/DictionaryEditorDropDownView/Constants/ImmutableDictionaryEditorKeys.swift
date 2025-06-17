//
//  ImmutableDictionaryEditorKeys.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 17.06.2025.
//

import Foundation

enum ImmutableDictionaryEditorKeys: String, CaseIterable {
    case data = "data"
    case dataType = "data type"
    case contentType = "Content-Type"
    
    init?(id : Int) {
            switch id {
            case 1: self = .data
            case 2: self = .dataType
            case 3: self = .contentType
            default: return nil
        }
    }
    
    static var allTypes: [String] {
        return ImmutableDictionaryEditorKeys.allCases.map { $0.rawValue }
    }
    
}
