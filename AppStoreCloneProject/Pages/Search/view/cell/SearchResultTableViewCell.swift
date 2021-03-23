//
//  SearchResultTableViewCell.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/23.
//

import UIKit
import RxCocoa
import RxSwift


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
public struct ResultTableViewCellData: Equatable {
    var wrapperType: String?
    var title: String?
    var description: String?
    var iconImageURL: String?
    var ratingScore: Double?
    var downloadCount: Int?
    var downloadURL: String?
    var bottomImageURLList: [String]?
}

class SearchResultTableViewCell: UITableViewCell {

    let disposeBag = DisposeBag()
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var ratingView: UIView!
    @IBOutlet weak var downLoadButton: UIButton!
    @IBOutlet weak var bottomCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        initStyle()
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
            $0.setFontAndColor(f: .systemFont(ofSize: 11), c: .secondaryLabel)
            $0.textAlignment = .left
            $0.numberOfLines = 1
        }
        
        self.ratingView.do {
            $0.backgroundColor = .purple
        }
        
        self.downLoadButton.do {
            $0.rx.tap.asDriver().drive(onNext: { [weak self] in
                print("\(self?.titleLabel.text ?? "")다운로드 버튼 클릭")
            }).disposed(by: self.disposeBag)
        }
    }
    
    func updateCellData(data: ResultTableViewCellData?) {
        guard let data = data else {
            //디폴트 데이터 노츌
            return
        }
        self.titleLabel.text = data.title
        self.descLabel.text = data.description
        self.iconImageView.setCacheImageURL(URL(string: data.iconImageURL ?? ""))
        self.bottomCollectionView.backgroundColor = .green
    }
}
