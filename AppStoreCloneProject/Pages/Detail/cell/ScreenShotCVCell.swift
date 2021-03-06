//
//  ScreenShotCVCell.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/23.
//

import UIKit

class ScreenShotCVCell: UICollectionViewCell {

    @IBOutlet var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initStyle()
    }
    
    override func prepareForReuse() {
        self.imageView.image = nil
    }

    func initStyle() {
        self.imageView.do {
            $0.contentMode = .scaleAspectFill
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
            $0.backgroundColor = UIColor(hex: AppColorString.grayLight.rawValue)
        }
    }
    
    func updateCellData(image: UIImage?) {
        guard let img = image else {
            return
        }
        
        self.imageView.image = img
    }
}
