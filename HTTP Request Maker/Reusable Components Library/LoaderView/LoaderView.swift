//
//  LoaderView.swift
//  HTTP Request Maker
//
//  Created by Anton Zyryanov on 17.06.2025.
//

import Foundation
import UIKit

class LoaderView: UIView {
    
    private var loaderImageView: UIImageView = UIImageView()
    
    func configureWith(gif: String) {
        let gif = UIImage.gifImageWithName(gif)
        loaderImageView = UIImageView(image: gif)
        self.addSubview(loaderImageView)
        loaderImageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.width.equalTo(250)
        }
    }
    
}
