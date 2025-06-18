//
//  DictionaryEditorItemViewModel.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 17.06.2025.
//

import Foundation

class DictionaryEditorItemViewModel {
    
    private var view: DictionaryEditorItemView
    private var model: DictionaryEditorItemModel
    
    init(view: DictionaryEditorItemView, model: DictionaryEditorItemModel) {
        self.view = view
        self.model = model
    }
    
}
