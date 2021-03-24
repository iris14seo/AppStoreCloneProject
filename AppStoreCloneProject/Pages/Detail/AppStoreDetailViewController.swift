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
        self.fetchDetailData()
        self.bindRxEvent()
    }
    
    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var topView: UIView!
    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var shortDescLabel: UILabel!
    @IBOutlet var downloadButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    
    @IBOutlet var moreInfoView: UIView!
    
    @IBOutlet var screenShotCollectionVIew: UICollectionView!

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
    var vmSoftWareData: SearchResultModel?
    
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
        
        self.supportDeviceLabel.do {
            $0.setFontAndColor(f: .boldSystemFont(ofSize: 15), c: .secondaryLabel)
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
    
    func updateData(data: SearchResultModel?) {
        guard let data = data else {
            return
        }
        
        self.titleLabel.text = data.trackName ?? "앱 이름"
        self.shortDescLabel.text = data.genres?.first ?? "설명"
        self.iconImageView.setCacheImageURL(URL(string: data.artworkUrl100 ?? ""))
        self.longDescLabel.text = data.description
        self.developerIDLabel.text = data.sellerName
    }
    
}
