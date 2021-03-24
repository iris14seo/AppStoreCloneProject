//
//  SearchResultTVCell.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/23.
//

import UIKit
import RxCocoa
import RxSwift
import Cosmos

/**검색 TableView의 search 타입 데이터 모델
 
 # 타입
 - 타이틀
 - 설명
 - 아이콘
 - 별점
 - 다운로드 횟수
 - 다운로드 URL
 - 콜렉션뷰 이미지 URLs
 */
public struct SoftWareCellData: Equatable {
    var title: String?
    var description: String?
    var iconImageURL: String?
    var ratingScore: Double?
    var downloadCount: Int?
    var downloadURL: String?
    var screenShotURLList: [String]?
}

class SearchResultTVCell: UITableViewCell {

    let disposeBag = DisposeBag()
    
    @IBOutlet var containerView: UIView!
    
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descLabel: UILabel!
    @IBOutlet var ratingView: CosmosView!
    @IBOutlet var downloadCountLabel: UILabel!
    @IBOutlet var downLoadButton: UIButton!
    
    @IBOutlet var screenShotImageView1: UIImageView!
    @IBOutlet var screenShotImageView2: UIImageView!
    @IBOutlet var screenShotImageView3: UIImageView!
    
    @IBOutlet var screenShotImageViewList: [UIImageView]!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        initStyle()
        bindRxEvent()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func initStyle() {
        self.selectionStyle = .none
        
        self.iconImageView.do {
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
        }
        
        self.titleLabel.do {
            $0.setFontAndColor(f: .systemFont(ofSize: 16), c: .label)
            $0.textAlignment = .left
            $0.numberOfLines = 1
        }
        
        self.descLabel.do {
            $0.setFontAndColor(f: .systemFont(ofSize: 14), c: .secondaryLabel)
            $0.textAlignment = .left
            $0.numberOfLines = 1
        }
        
        self.ratingView.do {
            $0.settings.updateOnTouch = false
            $0.settings.starSize = 15
            $0.settings.starMargin = 0.0
            $0.settings.filledColor = UIColor.secondaryLabel
            $0.settings.filledBorderColor = UIColor.secondaryLabel
            $0.settings.emptyBorderColor = UIColor.secondaryLabel
        }
        
        self.downloadCountLabel.do {
            $0.setFontAndColor(f: .systemFont(ofSize: 12), c: .secondaryLabel)
            $0.textAlignment = .left
            $0.numberOfLines = 1
        }
        
        self.downLoadButton.do {
            $0.rx.tap.asDriver().drive(onNext: { [weak self] in
                print("\(self?.titleLabel.text ?? "") 다운로드 버튼 클릭")
            }).disposed(by: self.disposeBag)
        }
        
        self.screenShotImageViewList.forEach {
            $0.layer.cornerRadius = 8
            $0.clipsToBounds = true
        }
    }
    
    func bindRxEvent() {
        self.downLoadButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            guard let self = self else { return }
            guard let topViewController = UIApplication.topViewController() else {
                return
            }
            showOKAlert(vc: topViewController, title: "다운로드", message: "\(self.titleLabel.text ?? "") 다운로드 버튼 클릭")
        }).disposed(by: self.disposeBag)
    }
    
    func updateCellData(data: SoftWareCellData?) {
        guard let data = data else {
            return
        }
        self.titleLabel.text = data.title
        self.descLabel.text = data.description
        self.iconImageView.setCacheImageURL(URL(string: data.iconImageURL ?? ""))
        self.ratingView.rating = data.ratingScore ?? 0
        self.downloadCountLabel.text = (data.downloadCount ?? 0).downloadUnit
        
        //MARK: 콜렉션뷰로 노출하기
        guard let urlStringList = data.screenShotURLList, urlStringList.count > 3 else {
            return
        }
        self.screenShotImageView1.setCacheImageURL(URL(string: urlStringList[0]))
        self.screenShotImageView2.setCacheImageURL(URL(string: urlStringList[1]))
        self.screenShotImageView3.setCacheImageURL(URL(string: urlStringList[2]))
    }
}
