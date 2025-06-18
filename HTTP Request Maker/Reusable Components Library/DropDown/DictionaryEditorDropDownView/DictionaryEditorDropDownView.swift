//
//  DictionaryDropDownView.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 17.06.2025.
//

import UIKit
import SnapKit

class DictionaryEditorDropDownView: UIView, DropDownProtocol {
    
    var parentView: DropDownParentProtocol?
    
    var presentButton: DropDownPresentButtonProtocol = DropDownPresentButton()

    var dictionaryEditorItemsViews: [DictionaryEditorItemView] = []
    
    var vStack = UIStackView()
    
    let vStackBottomSpacer = UIView()
    
    
    var model: DictionaryEditorModel?
    
    var delegate: DictionaryEditorDropDownViewDelegate?
    
    private var presentedDictionary: [(String,String)] = []
    
    func configureWith(model: DictionaryEditorModel) {
        self.model = model
        presentButton.configureWith(model: model.presentButtonModel)
        var dictionaryEditorItems: [DictionaryEditorItemModel] = []
        let freshDictionary: [String:String] = model.existingDictionary ?? [:]
        for v in freshDictionary {
            dictionaryEditorItems.append(DictionaryEditorItemModel.value((v.key,v.value)))
            presentedDictionary.append((v.key,v.value))
        }
        if model.numberOfNewElementsToAdd != 0 {
            for _ in 0..<model.numberOfNewElementsToAdd {
                dictionaryEditorItems.append(DictionaryEditorItemModel.empty)
                presentedDictionary.append(("",""))
            }
        }
        setupView(dictionaryEditorItems: dictionaryEditorItems)
    }
    
    private func setupView(dictionaryEditorItems: [DictionaryEditorItemModel]) {
        guard let model = model else { return }
        self.addSubview(vStack)
        setupVStack()
        setupPresentButton()
        setupDictionaryItems(dictionaryEditorItems, model)
        setupBottomSpacer()
        closeDropDown()
    }
    
    private func setupVStack() {
        vStack.snp.makeConstraints { make in
            make.leading.top.trailing.bottom.equalToSuperview()
        }
        vStack.backgroundColor = .white
        vStack.layer.cornerRadius = 16
        vStack.clipsToBounds = true
        vStack.axis = .vertical
        vStack.spacing = 8
        vStack.addArrangedSubview(presentButton)
    }
    
    private func setupPresentButton() {
        guard let model = model else { return }
        presentButton.snp.makeConstraints { make in
            make.height.equalTo(model.presentButtonHeight)
            make.width.equalToSuperview()
        }
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.presentButtonTapped))
        presentButton.addGestureRecognizer(tap)
    }
    
    private func setupDictionaryItems(_ dictionaryEditorItems: [DictionaryEditorItemModel], _ model: DictionaryEditorModel) {
        for (index, dictItem) in dictionaryEditorItems.enumerated() {
            let dictItemView = DictionaryEditorItemView()
            vStack.addArrangedSubview(dictItemView)
            dictItemView.snp.makeConstraints { make in
                make.height.equalTo(model.itemsHeight)
                make.width.equalToSuperview()
            }
            dictItemView.configureWith(model: dictItem)
            dictItemView.delegate = self
            dictItemView.index = index
            dictionaryEditorItemsViews.append(dictItemView)
            let vm = DictionaryEditorItemViewModel(view: dictItemView, model: dictItem)
        }
    }
    
    private func setupBottomSpacer() {
        vStack.addArrangedSubview(vStackBottomSpacer)
        vStackBottomSpacer.snp.makeConstraints { make in
            make.height.equalTo(32)
            make.width.equalToSuperview()
        }
    }
    
    private func openDropDown() {
        UIView.animate(withDuration: 0.3) { [self] in
            for view in dictionaryEditorItemsViews {
                view.isHidden = false
                vStackBottomSpacer.isHidden = false
            }
        }
    }
    
    private func closeDropDown() {
        UIView.animate(withDuration: 0.3) { [self] in
            for view in self.dictionaryEditorItemsViews {
                view.isHidden = true
                vStackBottomSpacer.isHidden = true
            }
        }
    }
    
    @objc func presentButtonTapped() {
        presentButton.isPresented.toggle()
            if presentButton.isPresented {
                openDropDown()
            } else {
                closeDropDown()
            }
    }

}

extension DictionaryEditorDropDownView: DictionaryEditorItemViewDelegate {
    func updateDictionary(item: (String, String), index: Int) {
        guard let dictType = model?.dictType else { return }
        var finalDictionary: [String:String] = [:]
        presentedDictionary[index] = (item.0,item.1)
        let notEmptyItems = presentedDictionary.filter { item in
            return (item.0 != "" && item.1 != "")
        }
        for notEmptyItem in notEmptyItems {
            finalDictionary[notEmptyItem.0] = notEmptyItem.1
        }
        delegate?.handeUpdateOf(dictionary: finalDictionary, dictType: dictType)
    }
}
