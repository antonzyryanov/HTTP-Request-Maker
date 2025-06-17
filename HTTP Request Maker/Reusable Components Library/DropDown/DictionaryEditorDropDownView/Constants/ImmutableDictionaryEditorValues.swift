//
//  ImmutableDictionaryEditorValues.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 17.06.2025.
//

import Foundation

enum ImmutableDictionaryEditorValues: String, CaseIterable {
    case applicationJSON = "application/json"
    
    init?(id : Int) {
            switch id {
            case 1: self = .applicationJSON
            default: return nil
        }
    }
    
    static var allTypes: [String] {
        return ImmutableDictionaryEditorValues.allCases.map { $0.rawValue }
    }
    
}
