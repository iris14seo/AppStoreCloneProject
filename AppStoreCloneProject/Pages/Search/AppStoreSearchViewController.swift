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
    func displayRecentWordList(viewModel: AppStoreSearch.RecentWord.ViewModel)
    func displaySearchWordList(viewModel: AppStoreSearch.SearchWord.ViewModel)
    func displayError(error: Error?)
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
        
        self.loadRecentWord(dataType: .all)
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
            $0.searchBar.placeholder = "음악, 영화, 책 등"
        }
        
        return sc
    }()
    
    lazy var searchResultTableViewController: SearchResultTableViewController = {
        let tv = SearchResultTableViewController()
        return tv
     
     //UISearchController(searchResultsController: searchResultTableViewController) //MARK: [고민] 테이블뷰 두개 겹쳐서 돌아가면서 나오게 하면 안될것 같다...
    }()
    
    //tableView
    @IBOutlet var recentWordTableView: UITableView!
    let recentWordReuseIdentifier = "RecentWordTableViewCell"
    
    
    //data
    var vmRecentWordDataList: [String]?
    
    
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
        }
    }
    
    func initRecentSearchedWordTableView() {
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
   
    func loadRecentWord(dataType: AppStoreSearch.RecentWord.Request.DataType, keyWord: String? = nil) {
        self.interactor?.loadRecentWordList(request: .init(dataType: dataType, keyWord: keyWord))
        self.updateTableViewMode(mode: .recentWord)
    }
    
    func requestMusicList(keyWord: String) {
        self.interactor?.requestSearchWordList(request: .init(keyWord: keyWord))
        self.updateTableViewMode(mode: .searchWord)
    }
    
    func displayRecentWordList(viewModel: AppStoreSearch.RecentWord.ViewModel) {
        guard let recentWordList = viewModel.recentWordList else {
            return
        }
        
        self.vmRecentWordDataList = recentWordList
        self.updateRecentWordTableView()
    }
    
    func displaySearchWordList(viewModel: AppStoreSearch.SearchWord.ViewModel) {
        
    }
    
    func displayError(error: Error?) {
        print(error?.localizedDescription ?? "error is occured")
    }
    
    func updateRecentWordTableView() {
        self.recentWordTableView.reloadData()
    }
    
    func updateTableViewMode(mode: AppStoreSearch.ViewMode) {
        switch mode {
        case .recentWord:
            self.searchingController = UISearchController(searchResultsController: nil)
        case .searchWord:
            self.searchingController = UISearchController(searchResultsController: searchResultTableViewController)
        }
    }
}

extension AppStoreSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text.count > 0 else { return }
        
        self.loadRecentWord(dataType: .filtered, keyWord: text)
    }
}

extension AppStoreSearchViewController: UISearchBarDelegate {
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        print("searchBarTextDidEndEditing", searchBar.text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("textDidChange", searchBar.text)
        
        if searchText.isEmpty {
            self.loadRecentWord(dataType: .all)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //let  char = text.cString(using: String.Encoding.utf8)!
        //let isBackSpace = strcmp(char, "\\b")
        if text.isEmpty { //(isBackSpace == -92) && (text.isEmpty)
            //print("Backspace was pressed and search bar text is empty")
            self.loadRecentWord(dataType: .all)
        }
        
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("서치 버튼 클릭")
        guard let text = searchBar.text, text.count > 0 else { return }
        
        self.requestMusicList(keyWord: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("서치 취소 클릭")
        
        self.loadRecentWord(dataType: .all)
    }
    
}

extension AppStoreSearchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let recentWordList = self.vmRecentWordDataList,
              !recentWordList.isEmpty else {
            //self.recentWordTableView.isHidden = true //MARK: 테스트 코드
            return 0
        }
                
        //self.recentWordTableView.isHidden = false //MARK: 테스트 코드
        return recentWordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let recentWordList = self.vmRecentWordDataList,
              indexPath.row < recentWordList.count else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.recentWordReuseIdentifier, for: indexPath) as! RecentWordTableViewCell
        cell.updateData(word: recentWordList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedWord = self.vmRecentWordDataList?[indexPath.row] else { return }
        
        print("선택한 단어로 검색하기")
        self.searchingController.searchBar.text = selectedWord
        self.requestMusicList(keyWord: selectedWord)
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
