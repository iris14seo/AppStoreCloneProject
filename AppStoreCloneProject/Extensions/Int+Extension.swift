//
//  Int+Extension.swift
//  AppStoreCloneProject
//
//  Created by 서문정(MunJeong Seo) on 2021/03/24.
//

import Foundation

extension Int {
    
    var downloadUnit: String {
        var temp = self
        
        if temp < 10000 {
            return "\(temp)"
        } else {
            temp = temp / 10000
            return "\(temp)만"
        }
    }
    
}
