//
//  SummaryInfoCVCell.swift
//  AppStoreCloneProject
//
//  Created by 서문정(MunJeong Seo) on 2021/03/24.
//

import UIKit
import Cosmos

public enum SummaryInfoCellType: Int {
    case ratingScore = 0 //averageUserRating 추가정보
    case downloadCount = 1//userRatingCount 추가정보
    case recommendedAge = 2//contentAdvisoryRating 추가정보
    case language = 3//languageCodesISO2A 추가정보
    case minimumOsVersion = 4//minimumOsVersion 추가정보
}

class SummaryInfoCVCell: UICollectionViewCell {

    @IBOutlet var topLabel: UILabel!
    @IBOutlet var middleLabel: UILabel!
    @IBOutlet var ratingStarView: CosmosView!
    @IBOutlet var bottomLabel: UILabel!
    
    @IBOutlet var rightLineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        initStyle()
    }
    
    override func prepareForReuse() {
        self.topLabel.text = nil
        self.middleLabel.text = nil
        self.bottomLabel.text = nil
        self.ratingStarView.rating = 0
        self.rightLineView.isHidden = false
    }

    func initStyle() {
        self.backgroundColor = .clear
        
        self.topLabel.do {
            $0.setFontAndColor(f: .systemFont(ofSize: 12), c: .secondaryLabel)
            $0.textAlignment = .center
            $0.numberOfLines = 1
            $0.text = ""
        }
        
        self.middleLabel.do {
            $0.setFontAndColor(f: .boldSystemFont(ofSize: 17), c: .secondaryLabel)
            $0.textAlignment = .center
            $0.numberOfLines = 1
            $0.text = ""
        }
        
        self.bottomLabel.do {
            $0.setFontAndColor(f: .systemFont(ofSize: 12), c: .secondaryLabel)
            $0.textAlignment = .center
            $0.numberOfLines = 1
            $0.text = ""
        }
        
        self.ratingStarView.do {
            $0.settings.updateOnTouch = false
            $0.settings.starSize = 14
            $0.settings.starMargin = 1.0
            $0.settings.filledColor = UIColor.secondaryLabel
            $0.settings.filledBorderColor = UIColor.secondaryLabel
            $0.settings.emptyBorderColor = UIColor.secondaryLabel
            $0.rating = 0

            $0.isHidden = true
        }
        
        self.rightLineView.isHidden = false
    }
    
    func updateCellData(type: SummaryInfoCellType.RawValue, data: AppStoreDetail.SoftWareDetailDataModel?, isLastCell: Bool) {
        guard let data = data else {
            return
        }
        
        self.rightLineView.isHidden = isLastCell //경계선
        
        switch type {
        case 0:
            self.ratingStarView.isHidden = false
            self.bottomLabel.isHidden = true
            
            self.topLabel.text = Int(data.ratingScore ?? 0).downloadUnit
            self.middleLabel.text = String(data.ratingScore ?? 0)
            self.ratingStarView.rating = data.ratingScore ?? 0
            
        case 1:
            self.ratingStarView.isHidden = true
            self.bottomLabel.isHidden = false
            
            self.topLabel.text = "다운횟수"
            self.middleLabel.text = data.downloadCount
            self.bottomLabel.text = "회"
            
        case 2:
            self.ratingStarView.isHidden = true
            self.bottomLabel.isHidden = false
            
            self.topLabel.text = "연령"
            self.middleLabel.text = (data.recommenedAge ?? "0+")
            self.bottomLabel.text = "세"
            
        case 3:
            self.ratingStarView.isHidden = true
            self.bottomLabel.isHidden = false
            
            self.topLabel.text = "언어"
            self.middleLabel.text = data.baseLanguage
            self.bottomLabel.text = "+ 기타 언어"
            
        case 4:
            self.ratingStarView.isHidden = true
            self.bottomLabel.isHidden = false
            
            self.topLabel.text = "최소 OS"
            self.middleLabel.text = data.minimumOsVersion
            self.bottomLabel.text = "버전"
        default:
            break
        }
    }
}
