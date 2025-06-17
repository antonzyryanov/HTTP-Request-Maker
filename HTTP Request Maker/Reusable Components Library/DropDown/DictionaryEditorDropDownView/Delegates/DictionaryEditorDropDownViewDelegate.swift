//
//  DictionaryEditorDropDownViewDelegate.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 17.06.2025.
//

import Foundation

protocol DictionaryEditorDropDownViewDelegate {
    func handeUpdateOf(dictionary: [String:String], dictType: CustomDictionaryOption)
}
