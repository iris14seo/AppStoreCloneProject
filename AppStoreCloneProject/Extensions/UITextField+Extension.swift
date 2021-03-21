//
//  UITextField+Extension.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit

extension UITextField {
    func addLeftPadding(_ padding: CGFloat = 10) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
        
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
    }
    
    func addRightPadding(_ padding: CGFloat = 10) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: self.frame.height))
        
        self.rightView = paddingView
        self.rightViewMode = ViewMode.always
    }
    
    func setAttributedPlaceHolder(t: String = "", f: UIFont, c: UIColor = .lightGray) {
        self.attributedPlaceholder = NSAttributedString(string: t, attributes: [NSAttributedString.Key.font: f, NSAttributedString.Key.foregroundColor: c])
    }
}

