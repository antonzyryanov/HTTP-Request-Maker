//
//  DictionaryEditorModel.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 17.06.2025.
//

import Foundation

struct DictionaryEditorModel {
    var presentButtonModel: DropDownPresentButtonModel
    var existingDictionary: [String:String]?
    var numberOfNewElementsToAdd: Int
    var presentButtonHeight: CGFloat
    var itemsHeight: CGFloat
    var dictType: CustomDictionaryOption?
}
