//
//  AppStoreDetailViewController.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit
import RxCocoa
import RxSwift

protocol AppStoreDetailDisplayLogic: class {
    func displayDetailData(viewModel: AppStoreDetail.FetchData.ViewModel)
}

typealias AppStoreDetailPage = AppStoreDetailViewController
class AppStoreDetailViewController: RXViewController, AppStoreDetailDisplayLogic {
    var interactor: AppStoreDetailBusinessLogic?
    var router: (NSObjectProtocol & AppStoreDetailRoutingLogic & AppStoreDetailDataPassing)?
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup() {
        let viewController = self
        let interactor = AppStoreDetailInteractor()
        let presenter = AppStoreDetailPresenter()
        let router = AppStoreDetailRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }
    
    // MARK: Routing
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let scene = segue.identifier {
            let selector = NSSelectorFromString("routeTo\(scene)WithSegue:")
            if let router = router, router.responds(to: selector) {
                router.perform(selector, with: segue)
            }
        }
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initStyle()
        self.bindRxEvent()
        
        self.fetchDetailData()
    }
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var topView: UIView!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var shortDescLabel: UILabel!
    @IBOutlet var downloadButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    
    @IBOutlet var moreInfoView: UIView!
    
    @IBOutlet var screenShotCollectionView: UICollectionView!
    let screenShotCVCell = "ScreenShotCVCell"
    let screenShotCVCellHeight: Double = 250
    let screenShotImageRatio: CGFloat =  0.5

    @IBOutlet var supportDeviceView: UIView!
    @IBOutlet var iphoneImageView: UIImageView!
    @IBOutlet var ipadImageView: UIImageView!
    @IBOutlet var supportDeviceLabel: UILabel!
    
    @IBOutlet var longDescView: UIView!
    @IBOutlet var longDescLabel: UILabel!
    
    @IBOutlet var developerView: UIView!
    @IBOutlet var developerIDLabel: UILabel!
    @IBOutlet var developerTextLabel: UILabel!
    
    //data
    private var vmSoftWareData: AppStoreDetail.SoftWareDetailDataModel?
    private var screenShotImageUrlStringList: [String]?
    
    // MARK: Do something
    
    func initStyle() {
        self.navigationController?.do {
            $0.navigationBar.prefersLargeTitles = false
        }
        
        self.scrollView.do {
            $0.backgroundColor = .systemBackground
        }
        
        self.iconImageView.do {
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
        }
        
        self.titleLabel.do {
            $0.setFontAndColor(f: .boldSystemFont(ofSize: 18), c: .label)
            $0.textAlignment = .left
            $0.numberOfLines = 1
            $0.text = ""
        }
        
        self.shortDescLabel.do {
            $0.setFontAndColor(f: .systemFont(ofSize: 11), c: .secondaryLabel)
            $0.textAlignment = .left
            $0.numberOfLines = 0
            $0.text = ""
        }
        
        self.downloadButton.do {
            $0.layer.cornerRadius = 10
            $0.clipsToBounds = true
            $0.setTitle("받기", for: .normal)
            $0.titleLabel?.setFontAndColor(f: .boldSystemFont(ofSize: 11), c: .white)
        }
        
        self.shareButton.do {
            $0.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        }
        
        self.screenShotCollectionView.do {
            $0.register(UINib.init(nibName: screenShotCVCell, bundle: nil), forCellWithReuseIdentifier: screenShotCVCell)
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .black
            $0.allowsMultipleSelection = false
            $0.showsHorizontalScrollIndicator = false
            $0.showsVerticalScrollIndicator = false
            
            if let layout = $0.collectionViewLayout as? UICollectionViewFlowLayout {
                layout.scrollDirection = .horizontal
                layout.minimumInteritemSpacing = 0
                layout.minimumLineSpacing = 0
            }
        }
        
        self.iphoneImageView.do {
            $0.isHidden = true
        }
        
        self.ipadImageView.do {
            $0.isHidden = true
        }
        
        self.supportDeviceLabel.do {
            $0.setFontAndColor(f: .boldSystemFont(ofSize: 12), c: .secondaryLabel)
            $0.text = ""
        }
        
        self.longDescLabel.do {
            $0.setFontAndColor(f: .systemFont(ofSize: 12), c: .label)
            $0.textAlignment = .left
            $0.numberOfLines = 0
            $0.text = ""
        }
        
        self.developerIDLabel.do {
            $0.setFontAndColor(f: .systemFont(ofSize: 14), c: .link)
            $0.textAlignment = .left
            $0.numberOfLines = 1
            $0.text = ""
        }
        
        self.developerTextLabel.do {
            $0.setFontAndColor(f: .systemFont(ofSize: 11), c: .secondaryLabel)
            $0.textAlignment = .left
            $0.numberOfLines = 1
            $0.text = "개발자"
        }
    }
    
    func bindRxEvent() {
        self.downloadButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            guard let self = self else { return }
            showOKAlert(vc: self, title: "다운로드", message: "\(self.titleLabel.text ?? "") 다운로드 버튼 클릭")
        }).disposed(by: self.disposeBag)
        
        self.shareButton.rx.tap.asDriver().drive(onNext: { [weak self] in
            guard let self = self else { return }
            showOKAlert(vc: self, title: "공유", message: "\(self.titleLabel.text ?? "") 공유 버튼 클릭")
        }).disposed(by: self.disposeBag)
    } 
    
    func fetchDetailData() {
        self.interactor?.fetchDetailData()
    }
    
    func displayDetailData(viewModel: AppStoreDetail.FetchData.ViewModel) {
        guard let vm = viewModel.data else {
            return
        }
        
        self.vmSoftWareData = vm
        self.updateData(data: vm)
    }
    
    func updateData(data: AppStoreDetail.SoftWareDetailDataModel?) {
        guard let data = data else {
            return
        }
        
        self.titleLabel.text = data.title ?? "앱 이름"
        self.shortDescLabel.text = data.genres
        self.iconImageView.setCacheImageURL(URL(string: data.iconImageURL ?? ""))
       
        self.screenShotImageUrlStringList = data.screenShotURLList
        
        let isSupportIphone = data.supportedDevices?.contains(.iPhone) ?? false
        let isSupportIpad = data.supportedDevices?.contains(.iPad) ?? false
        self.iphoneImageView.isHidden = !isSupportIphone
        self.ipadImageView.isHidden = !isSupportIpad
        self.supportDeviceLabel.text = getSupportedDevicesText(isSupportIphone: isSupportIphone, isSupportIpad: isSupportIpad)
        
        self.longDescLabel.text = data.longDescription
        self.developerIDLabel.text = data.developerID
    }
    
    func getSupportedDevicesText(isSupportIphone: Bool, isSupportIpad: Bool) -> String? {
        var text = ""
        if isSupportIphone {
            text.append("iPhone")
        }
        
        if isSupportIpad {
            if text.count > 0 {
                text.append(", ")
            }
            text.append("iPad")
        }
        
        return text
    }
    
}

extension AppStoreDetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return getCollectionViewCellSize(height: screenShotCVCellHeight, ratio: screenShotImageRatio)
    }
    
    func getCollectionViewCellSize(height: Double, ratio: CGFloat) -> CGSize{
        return CGSize(width: height * Double(ratio) , height: height)
    }
}
