//
//  AppStoreSearchViewController.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit
import SnapKit
import RxCocoa
import RxSwift

protocol AppStoreSearchDisplayLogic: class {
    //func displaySomething(viewModel: AppStoreSearch.Something.ViewModel)
}

typealias AppStoreSearchPage = AppStoreSearchViewController
class AppStoreSearchViewController: UIViewController, AppStoreSearchDisplayLogic {
    var interactor: AppStoreSearchBusinessLogic?
    var router: (NSObjectProtocol & AppStoreSearchRoutingLogic & AppStoreSearchDataPassing)?
    
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
        let interactor = AppStoreSearchInteractor()
        let presenter = AppStoreSearchPresenter()
        let router = AppStoreSearchRouter()
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
        
        self.initNavigation()
        self.initStyle()
        self.initRecentSearchedWordTableView()
        
        //test
        
        MusicDataManager.shared.getMusicList(keyWord: "AJR") { _ in
            print("done")
        }
        
    }
    
    // MARK: Do something
    
    let disposeBag = DisposeBag()
    
    //navigation
    let profileButtonWidth: CGFloat = 40
    let profileButtonTraillingConstarint: CGFloat = 20
    lazy var profileButton: UIButton =  {
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
        let sc = UISearchController(searchResultsController: nil)
        sc.do {
            $0.hidesNavigationBarDuringPresentation = true
            $0.automaticallyShowsCancelButton = true
            $0.obscuresBackgroundDuringPresentation = false
            $0.searchResultsUpdater = self
            $0.searchBar.delegate = self
            $0.searchBar.placeholder = "게임, 앱, 스토리 등"
        }
        
        return sc
    }()
    
    lazy var searchResultTableViewController: SearchResultTableViewController = {
        let tv = SearchResultTableViewController()
        return tv
    }()
    
    //tableView
    @IBOutlet var recentWordTableView: UITableView!
    let recentWordReuseIdentifier = "RecentWordTableViewCell"
    
    
    //data
    var targetArray: [String]?
    var userDefaultArray: [String] = ["카카오","카카오톡","카카오 뱅크","뱅크","카카오페이","카패","게임","애플","테스트","캌ㅋ","ㅋㅋㅇ","카카오택시","카톡","은행","배그","ㅁㅇㄹㅁ","하이","1","2","3","4","5","6","7","netflix","play"]
    var filteredArrray: [String] = []
    
    
    func initNavigation() {
        self.navigationItem.do {
            //서치 컨트롤
            $0.searchController = searchingController
            
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
            
//            let swipeUpRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
//            swipeUpRecognizer.direction = .up
//            $0.addGestureRecognizer(swipeUpRecognizer)
//
//            let swipeDownRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
//            swipeUpRecognizer.direction = .down
//            $0.addGestureRecognizer(swipeDownRecognizer)
        }
    }
    
    func initRecentSearchedWordTableView() {
        self.targetArray = self.userDefaultArray //나중에 인터렉터로 받아오기
        
        self.recentWordTableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(UINib(nibName: recentWordReuseIdentifier, bundle: nil), forCellReuseIdentifier: recentWordReuseIdentifier)
        }
    }
    
    @objc func handleSwipeGesture() {
        self.view.endEditing(true)
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

extension AppStoreSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //code
        guard let text = searchController.searchBar.text, text.count > 0 else { return }
        self.filteredArrray = self.userDefaultArray.filter{ $0.lowercased().contains(text) }
        self.targetArray = self.filteredArrray
        
        print("updateSearchResults")
        dump(self.filteredArrray)
        
        self.recentWordTableView.reloadData()
    }
    
    
}

extension AppStoreSearchViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidEndEditing", searchBar.text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange", searchBar.text)
        
        if searchText.isEmpty {
            self.filteredArrray = []
            self.targetArray = self.userDefaultArray
            
            self.recentWordTableView.reloadData()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //let  char = text.cString(using: String.Encoding.utf8)!
//        let isBackSpace = strcmp(char, "\\b")

        if text.isEmpty { //(isBackSpace == -92) && (text.isEmpty)
            print("Backspace was pressed and search bar text is empty")
            self.filteredArrray = []
            self.targetArray = self.userDefaultArray
            
            self.recentWordTableView.reloadData()
        }
        
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("서치 버튼 클릭")
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("서치 취소 클릭")
        
        self.filteredArrray = []
        self.targetArray = self.userDefaultArray
        
        self.recentWordTableView.reloadData()
    }
    
}

extension AppStoreSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let targetArray = self.targetArray,
              !targetArray.isEmpty else { //count > 0
            self.recentWordTableView.isHidden = true
            return 0
        }
                
        self.recentWordTableView.isHidden = false
        return targetArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let targetArray = self.targetArray,
              indexPath.row < targetArray.count else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.recentWordReuseIdentifier, for: indexPath) as! RecentWordTableViewCell
        cell.updateData(word: targetArray[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.searchingController.searchBar.text = self.targetArray?[indexPath.row]
        
        print("선택한 단어로 검색하기")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

extension AppStoreSearchViewController: UIScrollViewDelegate {
    //MARK: 투머치 자주 불림
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchingController.searchBar.endEditing(true)
    }
}
