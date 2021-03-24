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
public struct SoftWareCellDataModel: Equatable {
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
    
    @IBOutlet var screenShotCollectionView: UICollectionView!
    let screenShotCVCell = "ScreenShotCVCell"
    let minimumInteritemSpacing: CGFloat = 20
    
    //data
    private var screenShotImageUrlStringList: [String]?
    
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
    
    override func prepareForReuse() {
        //MARK: 애플에서 퍼포먼스 이슈로 비추한단다.
        //MARK: https://fluffy.es/solve-duplicated-cells/
        self.iconImageView.image = nil
        self.titleLabel.text = nil
        self.descLabel.text = nil
        self.ratingView.rating = 0
        self.downloadCountLabel.text = nil
    }
    
    func initStyle() {
        self.selectionStyle = .none
        
        self.iconImageView.do {
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
            $0.image = nil
        }
        
        self.titleLabel.do {
            $0.setFontAndColor(f: .systemFont(ofSize: 16), c: .label)
            $0.textAlignment = .left
            $0.numberOfLines = 1
            $0.text = ""
        }
        
        self.descLabel.do {
            $0.setFontAndColor(f: .systemFont(ofSize: 14), c: .secondaryLabel)
            $0.textAlignment = .left
            $0.numberOfLines = 1
            $0.text = ""
        }
        
        self.ratingView.do {
            $0.settings.updateOnTouch = false
            $0.settings.starSize = 15
            $0.settings.starMargin = 0.0
            $0.settings.filledColor = UIColor.secondaryLabel
            $0.settings.filledBorderColor = UIColor.secondaryLabel
            $0.settings.emptyBorderColor = UIColor.secondaryLabel
            $0.rating = 0
        }
        
        self.downloadCountLabel.do {
            $0.setFontAndColor(f: .systemFont(ofSize: 12), c: .secondaryLabel)
            $0.textAlignment = .left
            $0.numberOfLines = 1
            $0.text = ""
        }
        
        self.screenShotCollectionView.do {
            $0.register(UINib.init(nibName: screenShotCVCell, bundle: nil), forCellWithReuseIdentifier: screenShotCVCell)
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .clear
            $0.allowsMultipleSelection = false
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            $0.isUserInteractionEnabled = false
            
            if let layout = $0.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
                layout.minimumInteritemSpacing = minimumInteritemSpacing
                layout.minimumLineSpacing = 0
            }
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
    
    func updateCellData(data: SoftWareCellDataModel?) {
        guard let data = data else {
            return
        }
        self.titleLabel.text = data.title
        self.descLabel.text = data.description
        self.iconImageView.setCacheImageURL(URL(string: data.iconImageURL ?? ""))
        self.ratingView.rating = data.ratingScore ?? 0
        self.downloadCountLabel.text = (data.downloadCount ?? 0).downloadUnit
        
        self.screenShotImageUrlStringList = data.screenShotURLList
    }
    
    //func updateCollectionViewHeightConstraint() {
        //콜렉션뷰 높이 0.65 비율 맞게 업데이트
        //myCollectionViewHeightConstraint.constant = CGFloat(self.cellHeight)
//        self.setNeedsLayout()
//        self.layoutIfNeeded()
//    }
}

extension SearchResultTVCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let screenShotList = self.screenShotImageUrlStringList, screenShotList.count > 0 else {
            return 0
        }
        
        return screenShotList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let screenShotList = self.screenShotImageUrlStringList,
              screenShotList.count > indexPath.row else {
            return UICollectionViewCell()
        }
        
        let uCell: ScreenShotCVCell = collectionView.dequeueReusableCell(withReuseIdentifier: screenShotCVCell, for: indexPath) as! ScreenShotCVCell
        
        let imageUrl = URL(string: screenShotList[indexPath.row])
        ImageCacheManager.shared.getCacheImagebyURL(imageUrl, { (image) in
            uCell.updateCellData(image: image)
        })
        
        return uCell
    }
    
}
