//
//  TestFile.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/21.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift


class TestViewController: UIViewController {
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initNavigation()
        self.initStyle()
        self.initRecentSearchedWordTableView()
    }
    
    // MARK: Do something
    
    let disposeBag = DisposeBag()
    
    //navigation
    let profileButtonWidth: CGFloat = 40
    let profileButtonTraillingConstarint: CGFloat = 20
    lazy var profileButton: UIButton =  {  //let btn = UIBarButtonItem(image: UIImage(named: "icBearProfile"), style: .plain, target: self, action: #selector(handleProfileButtonTap(_:)))
        let btn = UIButton(frame: CGRect(x: 0, y: 0, width: profileButtonWidth, height: profileButtonWidth))
        btn.do {
            $0.backgroundColor = .clear
            $0.setImage(UIImage(named: "icBearProfile"), for: .normal)
            $0.layer.cornerRadius = btn.frame.height / 2
            $0.layer.masksToBounds = true
            $0.addTarget(self, action: #selector(handleProfileButtonTap(_:)), for: .touchUpInside)
        }
        
        return btn
    }()
    
    lazy var searchingController: UISearchController = {
        let sc = UISearchController(searchResultsController: resultTableViewController)
        sc.do {
            $0.hidesNavigationBarDuringPresentation = true
            $0.automaticallyShowsCancelButton = true
            $0.obscuresBackgroundDuringPresentation = false
            $0.searchResultsUpdater = self
            $0.searchBar.placeholder = "게임, 앱, 스토리 등"
        }
        
        return sc
    }()
    
    lazy var resultTableViewController: ResultTableViewController = {
        let tv = ResultTableViewController()
        return tv
    }()
    
    //tableView
    @IBOutlet var recentWordTableView: UITableView!
    
    
    //data
    var userDefaultArray: [String] = ["카카오","카카오톡","카카오 뱅크","뱅크","카카오페이","카패","게임","애플","테스트","캌ㅋ","ㅋㅋㅇ","카카오택시","카톡","은행","배그","ㅁㅇㄹㅁ","하이","a","apple","ace","hi","haha","dump","netf","netflix","adsfa", "kaka", "play", "hard", "chill", "rabbit"]
    var filteredArrray: [String] = []
    
    
//    lazy var containerView: UIView = {
//        let view = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 60))
//        view.backgroundColor = .red
//        return view
//    }()
    
    func initNavigation() {
       
//        self.profileButton.do {
//
//            //add btn to navigationItem
//            let containerView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 40))
//            containerView.addSubview($0)
//            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: containerView)
//
//             $0.translatesAutoresizingMaskIntoConstraints = false
//             $0.snp.makeConstraints{ (make) in
//                 make.right.equalTo(containerView.snp.right).inset(self.profileButtonTraillingConstarint)
//                 make.bottom.equalTo(containerView.snp.bottom)
//                 make.width.equalTo(self.profileButtonWidth)
//                 make.height.equalTo(self.profileButtonWidth)
//             }
//        }
        
        self.navigationItem.do {
            $0.searchController = searchingController
            //$0.titleView = containerView
            
            //타이틀
            $0.title = "검색"
            self.navigationController?.navigationBar.prefersLargeTitles = true //MARK: 이거 안쓰고 커스텀 뷰에 라지 타이틀이랑 버튼 넣어보기
            
            //스크롤 액션
            $0.hidesSearchBarWhenScrolling = false
        }
    }
    
    func initStyle() {
        self.view.do {
            $0.backgroundColor = .systemBackground
        }
    }
    
    func initRecentSearchedWordTableView() {
        self.recentWordTableView.do {
            $0.delegate = self
            $0.dataSource = self
        }
    }
    
    @objc func handleProfileButtonTap(_ sender: Any) {
        print("프로필 버튼 클릭")
    }
   
    //  func doSomething() {
    //    let request = AppStoreSearch.Something.Request()
    //    interactor?.doSomething(request: request)
    //  }
    
    //  func displaySomething(viewModel: AppStoreSearch.Something.ViewModel) {
    //    //nameTextField.text = viewModel.name
    //  }
}

/*extension AppStoreSearchViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if (scrollView.contentOffset.y < 100) {
            //네비게이션 바 이름 지우기
            self.navigationController?.beginAppearanceTransition(true, animated: true)
            self.navigationController?.navigationItem.titleView = containerView
        } else {
            //네비게이션 바 이름 쓰기
            self.navigationController?.beginAppearanceTransition(true, animated: true)
            self.navigationController?.navigationItem.titleView = nil
        }
    }
}*/

extension TestViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //code
        guard let text = searchController.searchBar.text else { return }
        self.filteredArrray = self.userDefaultArray.filter { $0.lowercased().contains(text) }

        dump(self.filteredArrray)
    }
}

extension TestViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        30
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}



class SearchingWordHeaderView: UIView {

    let disposeBag = DisposeBag()

    //title
    @IBOutlet var titleAndProfileContainer: UIView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var profileImageButton: UIButton!

    //search
    @IBOutlet var searchContainerView: UIView!

    @IBOutlet var searchingWordInputTextFieldContainer: UIView!
    @IBOutlet var searchingWordIconImageView: UIImageView!
    @IBOutlet var searchingWordInputTextField: UITextField!

    @IBOutlet var deleteSearchingWordButton: UIButton!
    @IBOutlet var cancelSearchingModeButton: UIButton!

    //line
    @IBOutlet var grayLineView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.initStyle()
    }

    func initStyle() {

        self.titleAndProfileContainer.do {
            $0.backgroundColor = .clear
        }

        self.titleLabel.do {
            $0.text = "검색"
            $0.textAlignment = .left
            $0.setFontAndColor(f: .boldSystemFont(ofSize: 23), c: .label)
        }

        self.profileImageButton.do {
            $0.imageView?.image = UIImage(named: "icBearProfile")
            $0.layer.cornerRadius = $0.frame.width / 2
            $0.clipsToBounds = true
        }

        self.searchContainerView.do {
            $0.backgroundColor = .clear
        }

        self.searchingWordInputTextFieldContainer.do {
            $0.backgroundColor = .init(hex: AppColorString.grayLight.rawValue)
            $0.layer.cornerRadius = 10
        }

        self.searchingWordIconImageView.do {
            $0.image = UIImage(named: "icSearch")?.withRenderingMode(.alwaysTemplate)
            $0.tintColor = .init(hex: AppColorString.grayText.rawValue)
        }

        self.searchingWordInputTextField.do {
            $0.text = ""
            $0.setAttributedPlaceHolder(t: "게임, 앱, 스토리 등", f: .systemFont(ofSize: 13), c: .init(hex: AppColorString.grayText.rawValue))

            $0.rx.controlEvent([.editingDidBegin]).asObservable().subscribe(onNext: { [weak self] _ in
                UIView.animate(withDuration: 0.25) {
                    self?.cancelSearchingModeButton.isHidden = false
                    self?.grayLineView.isHidden = false
                    self?.titleAndProfileContainer.isHidden = true

                    self?.searchContainerView.backgroundColor = .init(hex: AppColorString.grayLight.rawValue, alpha: 0.5)
                }
            }).disposed(by: self.disposeBag)

            $0.rx.controlEvent([.editingChanged]).asObservable().subscribe(onNext: { [weak self] _ in
                if let text = self?.searchingWordInputTextField.text,
                   text.count > 0 {
                    self?.deleteSearchingWordButton.isHidden = false
                } else {
                    self?.deleteSearchingWordButton.isHidden = true
                }
            }).disposed(by: self.disposeBag)
        }

        self.deleteSearchingWordButton.do {
            $0.isHidden = true

            $0.rx.controlEvent([.touchUpInside]).asObservable().subscribe(onNext: { [weak self] _ in
                self?.searchingWordInputTextField.text = ""
                self?.deleteSearchingWordButton.isHidden = true
            }).disposed(by: self.disposeBag)
        }

        self.cancelSearchingModeButton.do {
            $0.isHidden = true
            $0.setTitle("취소", for: .normal)
            $0.titleLabel?.font = .systemFont(ofSize: 15.5)

            $0.rx.tap.asObservable().subscribe(onNext: { [weak self] _ in

                self?.endEditing(true)
                UIView.animate(withDuration: 0.25) {
                    self?.cancelSearchingModeButton.isHidden = true
                    self?.grayLineView.isHidden = true
                    self?.titleAndProfileContainer.isHidden = false

                    self?.searchContainerView.backgroundColor = .clear
                }

            }).disposed(by: self.disposeBag)
        }

        self.grayLineView.do {
            $0.backgroundColor = .init(hex: AppColorString.grayText.rawValue)
            $0.isHidden = true
        }
    }
}
