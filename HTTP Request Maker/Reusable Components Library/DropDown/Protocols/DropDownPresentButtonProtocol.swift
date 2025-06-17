//
//  DropDownPresentButtonProtocol.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 17.06.2025.
//

import Foundation
import UIKit

protocol DropDownPresentButtonProtocol: UIView {
    var isPresented: Bool { get set }

    var label : UILabel { get }
    
    var arrowImageView: UIImageView { get }
    
    var model: DropDownPresentButtonModel { get set }
    
    func configureWith(model: DropDownPresentButtonModel)
}
