//
//  UINavigation+Extension.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit

extension UINavigationController {
    func setBackGroundColorTransparent() {
        self.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationBar.shadowImage = UIImage()
        self.navigationBar.isTranslucent = true
    }
    
    func setAttributedTitle(f: UIFont, c: UIColor) {
        let textAttributes = [NSAttributedString.Key.foregroundColor: c, NSAttributedString.Key.font: f]
        self.navigationBar.titleTextAttributes = textAttributes
    }
}

extension UINavigationItem {
    func setTitle(title: String = "",
                  hideTitleAtFirst: Bool = false) {
        
        self.titleView = hideTitleAtFirst ? UILabel() : nil //처음에 네비 타이틀 숨기기
        self.title = title
    }
}
