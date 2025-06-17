//
//  VCWithCustomTabBar.swift
//  Zeros Cantina
//
//  Created by Anton Zyryanov on 14.06.2025.
//

import UIKit

class VCWithCustomTabBar: UIViewController {
    
    let tabBar: CustomTabBar = CustomTabBar()

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let backgroundImage = UIImage(named: "stars_background")
        let backgroundImageView = UIImageView(image: backgroundImage)
        self.view.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().inset(64)
        }
        backgroundImageView.clipsToBounds = true
        self.view.addSubview(tabBar)
        tabBar.snp.makeConstraints { make in
            make.height.equalTo(150)
            make.leading.trailing.top.equalToSuperview()
        }
    }

}
