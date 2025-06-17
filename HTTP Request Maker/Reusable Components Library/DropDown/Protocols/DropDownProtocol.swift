//
//  DropDownProtocol.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 17.06.2025.
//

import Foundation

import UIKit

protocol DropDownProtocol: UIView {
    var parentView: DropDownParentProtocol? { get set }
    var presentButton: DropDownPresentButtonProtocol { get set }
}
