//
//  DictionaryEditorItemViewDelegate.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 17.06.2025.
//

import Foundation

protocol DictionaryEditorItemViewDelegate {
    func updateDictionary(item: (String,String), index: Int)
}
