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
    func displayHistoryWordList(viewModel: AppStoreSearch.HistoryWord.ViewModel)
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
        self.initHistoryWordTableView()
        
        self.loadHistoryWord(dataType: .all)
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
    
    lazy var searchResultTableViewController: SearchResultTableViewController = {
        let tv = SearchResultTableViewController()
        tv.view.backgroundColor = .red
        tv.tableView.backgroundColor = .green
        return tv
    }()
    
    lazy var searchingController: UISearchController = {
        let sc = UISearchController(searchResultsController: searchResultTableViewController)
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
    
    //tableView
    let mainCell = "MainTableViewCell"
    @IBOutlet var mainTableView: UITableView!
    
    //data
    var vmHistoryWordList: [String]?
    
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
    
    func initHistoryWordTableView() {
        self.mainTableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.separatorColor = .clear
            $0.register(UINib(nibName: mainCell, bundle: nil), forCellReuseIdentifier: mainCell)
        }
    }
    
    @objc func handleSwipeGesture() {
        self.view.endEditing(true)
    }
    
    @objc func handleProfileButtonTap(_ sender: Any) {
        print("프로필 버튼 클릭")
    }
   
    func loadHistoryWord(dataType: AppStoreSearch.HistoryWord.Request.DataType, keyWord: String? = nil) {
        //MARK: 모드 바꾸기
        self.interactor?.loadHistoryWordList(request: .init(dataType: dataType, keyWord: keyWord))
        //self.updateTableViewMode(mode: .historyWord)
    }
    
    func requestITunesSearchDataList(keyWord: String) {
        //MARK: 모드 바꾸기***
        self.interactor?.requestSearchWordList(request: .init(keyWord: keyWord))
        //self.updateTableViewMode(mode: .searchWord)
    }
    
    func displayHistoryWordList(viewModel: AppStoreSearch.HistoryWord.ViewModel) {
        guard let historyWordList = viewModel.historyWordList else {
            return
        }
        
        self.vmHistoryWordList = historyWordList
        self.updateHistoryWordTableView()
    }
    
    func displaySearchWordList(viewModel: AppStoreSearch.SearchWord.ViewModel) {
        
    }
    
    func displayError(error: Error?) {
        print(error?.localizedDescription ?? "error is occured")
    }
    
    func updateHistoryWordTableView() {
        self.mainTableView.reloadData()
    }
//
//    func updateTableViewMode(mode: AppStoreSearch.ViewMode) {
//        switch mode {
//        case .historyWord:
//            self.searchingController = UISearchController(searchResultsController: nil)
//        case .searchWord:
//            self.searchingController = UISearchController(searchResultsController: searchResultTableViewController)
//        }
//    }
}

extension AppStoreSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text.count > 0 else { return }
        
        self.loadHistoryWord(dataType: .filtered, keyWord: text)
    }
}

extension AppStoreSearchViewController: UISearchBarDelegate {
//    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        print("searchBarTextDidEndEditing", searchBar.text)
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //print("textDidChange", searchBar.text)
        
        if searchText.isEmpty {
            self.loadHistoryWord(dataType: .all)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        //let  char = text.cString(using: String.Encoding.utf8)!
        //let isBackSpace = strcmp(char, "\\b")
        if text.isEmpty { //(isBackSpace == -92) && (text.isEmpty)
            //print("Backspace was pressed and search bar text is empty")
            self.loadHistoryWord(dataType: .all)
        }
        
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("서치 버튼 클릭")
        guard let text = searchBar.text, text.count > 0 else { return }
        
        self.requestITunesSearchDataList(keyWord: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("서치 취소 클릭")
        
        self.loadHistoryWord(dataType: .all)
    }
    
}

extension AppStoreSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "최근 검색어" //MARK: 임시
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let historyWordList = self.vmHistoryWordList,
              !historyWordList.isEmpty else {
            //self.recentWordTableView.isHidden = true //MARK: 테스트 코드
            return 0
        }
                
        //self.recentWordTableView.isHidden = false //MARK: 테스트 코드
        return historyWordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let historyWordList = self.vmHistoryWordList,
              indexPath.row < historyWordList.count else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.mainCell, for: indexPath) as! MainTableViewCell
        cell.updateCellData(word: historyWordList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedWord = self.vmHistoryWordList?[indexPath.row] else { return }
        
        print("선택한 단어로 검색하기")
        self.searchingController.searchBar.text = selectedWord
        self.requestITunesSearchDataList(keyWord: selectedWord)
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
