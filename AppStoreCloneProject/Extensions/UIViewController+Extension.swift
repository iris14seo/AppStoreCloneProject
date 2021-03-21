//
//  UIViewController+Extension.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/21.
//

import UIKit

extension UIViewController {
    func showNavigationBarTitle() {
        self.navigationController?.beginAppearanceTransition(true, animated: true)
        self.navigationItem.titleView = nil
    }

    func hideNavigationBarTitle() {
        self.navigationController?.beginAppearanceTransition(true, animated: true)
        self.navigationItem.titleView = UILabel()
    }
}
