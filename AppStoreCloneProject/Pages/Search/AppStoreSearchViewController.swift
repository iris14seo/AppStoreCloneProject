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
    func displayAllHistoryWordList(viewModel: AppStoreSearch.AllHistoryWord.ViewModel)
    func displayFilteredHistoryWordList(viewModel: AppStoreSearch.FilteredHistoryWord.ViewModel)
    func displaySearchWordList(viewModel: AppStoreSearch.SearchWord.ViewModel)
    func displayError(error: Error?)
}

typealias AppStoreSearchPage = AppStoreSearchViewController
class AppStoreSearchViewController: RXViewController, AppStoreSearchDisplayLogic {
    
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
        
        self.fetchMainTableView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.view.layoutIfNeeded()
        self.navigationController?.do {
            $0.navigationBar.prefersLargeTitles = true
        }
    }
    
    // MARK: Do something
    
    lazy var searchResultTableViewController: SearchResultTableViewController = {
        let tv = SearchResultTableViewController()
        tv.delegate = self
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
            $0.searchBar.placeholder = "게임, 앱, 스토리 등"
            $0.searchBar.setValue("취소", forKey: "cancelButtonText")
        }
        
        return sc
    }()
    
    //tableView
    let mainCell = "MainTVCell"
    let mainCellHeight: CGFloat = 40.0
    
    let mainSectionView: String = "MainTVSectionView"
    let mainSectionHeight: CGFloat = 45.0
    
    @IBOutlet var mainTableView: UITableView!
    
    //data
    var allHistoryWordList: [String]?
    
    func initNavigation() {
        self.navigationItem.do {
            //서치 컨트롤
            $0.searchController = searchingController
            
            //타이틀
            $0.title = "검색"
            self.navigationController?.navigationBar.prefersLargeTitles = true
            
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
            $0.register(UINib.init(nibName: mainSectionView, bundle: nil), forHeaderFooterViewReuseIdentifier: mainSectionView)
        }
    }
    
    func fetchMainTableView() {
        self.interactor?.loadAllHistoryWordList(request: .init())
    }
    
    func fetchFilteredHistoryWord(keyWord: String) {
        self.searchResultTableViewController.keyWord = keyWord
        self.interactor?.loadFilteredHistoryWordList(request: .init(keyWord: keyWord))
    }
    
    func requestAPISearch(keyWord: String) {
        self.searchResultTableViewController.keyWord = keyWord
        self.interactor?.requestSearchWordList(request: .init(keyWord: keyWord))
    }
    
    func displayAllHistoryWordList(viewModel: AppStoreSearch.AllHistoryWord.ViewModel) {
        guard let historyWordList = viewModel.historyWordList else {
            return
        }
        
        self.updateMainTableView(dataList: historyWordList)
    }
    
    func updateMainTableView(dataList: [String]?) {
        self.allHistoryWordList = dataList
        self.mainTableView.reloadData()
    }
    
    func displayFilteredHistoryWordList(viewModel: AppStoreSearch.FilteredHistoryWord.ViewModel) {
        guard let historyWordList = viewModel.historyWordList else {
            return
        }
        
        self.updateSearchWordTableView(withLocalHistory: historyWordList)
    }
    
    func displaySearchWordList(viewModel: AppStoreSearch.SearchWord.ViewModel) {
        guard let searchWordList = viewModel.softWareDataList else {
            return
        }
        
        self.updateSearchWordTableView(withAPISearch: searchWordList)
    }
    
    func updateSearchWordTableView(withLocalHistory dataList: [String]?) {
        self.searchResultTableViewController.currentResultType = .localHistory
        self.searchResultTableViewController.historyWordList = dataList
        
        DispatchQueue.main.async {
            self.searchResultTableViewController.tableView.reloadData()
        }
    }
    
    func updateSearchWordTableView(withAPISearch dataList: [SoftWareCellDataModel]?) {
        if (dataList?.count ?? 0) > 0 {
            self.searchResultTableViewController.currentResultType = .apiSearch
            self.searchResultTableViewController.searchDataList = dataList
        } else {
            self.searchResultTableViewController.currentResultType = .noResult
            self.searchResultTableViewController.searchDataList = nil
        }
        
        DispatchQueue.main.async {
            self.searchResultTableViewController.tableView.reloadData()
        }
    }
    
    func displayError(error: Error?) {
        print(error?.localizedDescription ?? "error is occured")
    }
}

// SearchResultTVCellDelegate
extension AppStoreSearchViewController: SearchResultTVCellDelegate {
    func onClickHistoryCellForSearch(keyWord: String) {
        self.searchingController.searchBar.text = keyWord
        self.requestAPISearch(keyWord: keyWord)
    }
    
    func hideSearchBarKeyBoard() {
        self.searchingController.searchBar.endEditing(true)
    }
    
    func routeToDetailPage(index: Int) {
        self.router?.routeToMemoDetailPage(index: index)
    }
}

// UISearchResultsUpdating, UISearchBarDelegate
extension AppStoreSearchViewController: UISearchResultsUpdating, UISearchBarDelegate {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text, text.count > 0 else { return }
        self.fetchFilteredHistoryWord(keyWord: text)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            print("서치바 딜리트 버튼 Tap")
            self.fetchMainTableView()
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = NSString(string: searchBar.text!).replacingCharacters(in: range, with: text)
        
        print("서치바 텍스트 입력중 자동 검색", newText)
        self.fetchFilteredHistoryWord(keyWord: newText)
        
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchingController.searchBar.endEditing(true)

        print("서치바 키보드 엔터 버튼 Tap")
        guard let text = searchBar.text, text.count > 0 else { return }
        self.requestAPISearch(keyWord: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("서치 취소 버튼 Tap")
        self.fetchFilteredHistoryWord(keyWord: "")
        self.fetchMainTableView()
    }
    
}

// UITableViewDelegate, UITableViewDataSource
extension AppStoreSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return mainSectionHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return mainCellHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let historyWordList = self.allHistoryWordList,
              !historyWordList.isEmpty else {
            return 0
        }
        
        return historyWordList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let historyWordList = self.allHistoryWordList,
              indexPath.row < historyWordList.count else {
            return UITableViewCell()
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.mainCell, for: indexPath) as! MainTVCell
        cell.updateCellData(text: historyWordList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: mainSectionView) as! MainTVSectionView
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let wordList = self.allHistoryWordList,
              wordList.count > indexPath.row else {
            return
        }
        
        //메인 테이블뷰 didSelectRow로 검색
        self.searchingController.searchBar.becomeFirstResponder()
        self.searchingController.searchBar.endEditing(true)
        
        let keyWord = wordList[indexPath.row]
        self.searchingController.searchBar.text = keyWord
        self.requestAPISearch(keyWord: keyWord)
    }
}
