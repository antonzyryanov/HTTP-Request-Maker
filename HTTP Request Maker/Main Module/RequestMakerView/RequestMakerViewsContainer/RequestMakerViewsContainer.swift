//
//  RequestMakerViewsContainer.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 18.06.2025.
//

import Foundation
import UIKit

class RequestMakerViewsContainer {
    let scrollView = UIScrollView()
    let verticalStack = UIStackView()
    let serverAddressTextField = UITextField()
    let secureConnectionSwitch = CustomSwitch()
    let secureConnectionValidationSwitch = CustomSwitch()
    let httpMethodPicker = UIPickerView()
    let customHTTPHeadersDropDown = DictionaryEditorDropDownView()
    let customHTTPBodyDropDown = DictionaryEditorDropDownView()
    let serverResponseLabel = TopAlignedLabel()
    let responseStatusLabel = TopAlignedLabel()
    let responseErrorLabel = TopAlignedLabel()
    let responseLabel = TopAlignedLabel()
}
