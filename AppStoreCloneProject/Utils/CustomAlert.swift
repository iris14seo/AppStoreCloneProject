//
//  CustomAlert.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/01.
//

import Foundation
import UIKit

public func showOKAlert(vc: UIViewController, title: String?, message: String? = nil, okAction: UIAlertAction? = nil) {
    let alert = UIAlertController(title: title,
                                  message: message,
                                  preferredStyle: .alert)
    
    var alertOKAction = okAction
    if alertOKAction == nil {
        alertOKAction = UIAlertAction(title: "확인",
                                          style: .default,
                                          handler: nil)
    }
    alert.addAction(alertOKAction!)
    
    vc.present(alert, animated: false, completion: nil)
}

