//
//  RequestMakerVC+UIScrollViewDelegate.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 17.06.2025.
//

import Foundation
import UIKit

extension RequestMakerViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x != 0 {
            scrollView.contentOffset.x = 0
        }
    }
}
