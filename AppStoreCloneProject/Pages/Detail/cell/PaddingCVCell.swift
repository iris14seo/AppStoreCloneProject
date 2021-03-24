//
//  PaddingCVCell.swift
//  AppStoreCloneProject
//
//  Created by 서문정(MunJeong Seo) on 2021/03/24.
//

import UIKit

class PaddingCVCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        initStyle()
    }

    func initStyle() {
        self.backgroundColor = .clear
    }
}
