//
//  DictionaryEditorItemView.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 17.06.2025.
//

import UIKit

class DictionaryEditorItemView: UIView {

    let keyTextView = UITextView()
    let valueTextView = UITextView()
    let horizontalStack = UIStackView()
    var index: Int = 0
    
    var delegate: DictionaryEditorItemViewDelegate?
    
    func configureWith(model: DictionaryEditorItemModel) {
        self.backgroundColor = .white
        switch model {
        case .empty:
            keyTextView.text = ""
            valueTextView.text = ""
        case .value(let dictItem):
            keyTextView.text = dictItem.0
            valueTextView.text = dictItem.1
            if ImmutableDictionaryEditorKeys.allTypes.contains(dictItem.0) {
                keyTextView.isUserInteractionEnabled = false
            }
            if ImmutableDictionaryEditorValues.allTypes.contains(dictItem.1) {
                valueTextView.isUserInteractionEnabled = false
            }
        }
        self.addSubview(horizontalStack)
        horizontalStack.snp.makeConstraints { make in
            make.bottom.top.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(16)
        }
        horizontalStack.axis = .horizontal
        horizontalStack.spacing = 12
        horizontalStack.addArrangedSubview(keyTextView)
        horizontalStack.addArrangedSubview(valueTextView)
        keyTextView.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.width.equalTo(UIScreen.main.bounds.width/2 - 54)
        }
        valueTextView.snp.makeConstraints { make in
            make.height.equalTo(64)
            make.width.equalTo(UIScreen.main.bounds.width/2 - 54)
        }
        keyTextView.backgroundColor = UIColor.init(red: 181/255, green: 224/255, blue: 140/255, alpha: 1)
        valueTextView.backgroundColor = UIColor.init(red: 181/255, green: 224/255, blue: 140/255, alpha: 1)
        keyTextView.textStorage.delegate = self
        valueTextView.textStorage.delegate = self
    }
    
}

extension DictionaryEditorItemView: NSTextStorageDelegate {
    func textStorage(_ textStorage: NSTextStorage, didProcessEditing editedMask: NSTextStorage.EditActions, range editedRange: NSRange, changeInLength delta: Int) {
        delegate?.updateDictionary(item: (keyTextView.text, valueTextView.text), index: index)
    }
}
