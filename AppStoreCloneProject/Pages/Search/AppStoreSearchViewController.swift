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
        
        self.fetchAllHistoryWord() //MARK: [이슈] viewWillAppear로 위치 옮기기
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
    let mainCellHeight: CGFloat = 40
    
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
    
    func bindSearchController() {
        
    }
    
    @objc func handleSwipeGesture() {
        self.view.endEditing(true)
    }
    
    func fetchAllHistoryWord() {
        self.interactor?.loadAllHistoryWordList(request: .init())
    }
    
    func fetchSearchResult(cellType: AppStoreSearch.ResultType, keyWord: String? = nil) {
        self.interactor?.loadFilteredHistoryWordList(request: .init(keyWord: keyWord))
        self.updateSearchWordType(type: .history)
    }
    
    func requestSoftWareDataList(keyWord: String) {
        self.interactor?.requestSearchWordList(request: .init(keyWord: keyWord))
        self.updateSearchWordType(type: .search)
    }
    
    func displayAllHistoryWordList(viewModel: AppStoreSearch.AllHistoryWord.ViewModel) {
        guard let historyWordList = viewModel.historyWordList else {
            return
        }
        
        self.updateHistoryWordTableView(dataList: historyWordList)
    }
    
    func updateHistoryWordTableView(dataList: [String]?) {
        dump(dataList)
        
        self.allHistoryWordList = dataList
        self.mainTableView.reloadData()
    }
    
    func displayFilteredHistoryWordList(viewModel: AppStoreSearch.FilteredHistoryWord.ViewModel) {
        guard let historyWordList = viewModel.historyWordList else {
            return
        }
        
        self.updateSearchWordTableView(dataList: historyWordList, type: .history)
    }
    
    func updateSearchWordTableView(dataList: [Any]?, type: AppStoreSearch.ResultType) {
        dump(dataList)
        
        if (dataList?.count ?? 0) > 0 {
            
            if type == .history {
                let historyList = dataList as? [String]
                self.searchResultTableViewController.historyWordList = historyList
            } else if type == .search {
                let searchList = dataList as? [SoftWareCellDataModel]
                self.searchResultTableViewController.searchDataList = searchList
            }
            
        } else {
            self.updateSearchWordType(type: .notFound)
        }
        
        DispatchQueue.main.async {
            self.searchResultTableViewController.tableView.reloadData()
        }
    }
    
    func updateSearchWordType(type: AppStoreSearch.ResultType) {
        self.searchResultTableViewController.currentResultType = type
    }
    
    func displaySearchWordList(viewModel: AppStoreSearch.SearchWord.ViewModel) {
        guard let searchWordList = viewModel.softWareDataList else {
            return
        }
        
        self.updateSearchWordTableView(dataList: searchWordList, type: .search)
    }
    
    func displayError(error: Error?) {
        print(error?.localizedDescription ?? "error is occured")
    }
}

extension AppStoreSearchViewController: SearchResultTVCellDelegate {
    func onClickHistoryCellForSearch(word: String) {
        self.searchingController.searchBar.text = word
        self.requestSoftWareDataList(keyWord: word)
    }
    
    func hideSearchBarKeyBoard() {
        self.searchingController.searchBar.endEditing(true)
    }
    
    func routeToDetailPage(index: Int) {
        self.router?.routeToMemoDetailPage(index: index)
    }
}

extension AppStoreSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        //이슈: 첫 진입시에만 포커싱될때 포커스 아웃됨(튕김)
        guard let text = searchController.searchBar.text, text.count > 0 else { return }
        self.fetchSearchResult(cellType: .search, keyWord: text)
    }
}

extension AppStoreSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            //MARK: 필요한지 다시 고민
            self.fetchSearchResult(cellType: .search)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.isEmpty {
            //MARK: 필요한지 다시 고민
            self.fetchSearchResult(cellType: .search)
        }
        
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("서치 버튼 클릭")
        self.searchingController.searchBar.endEditing(true)
        
        guard let text = searchBar.text, text.count > 0 else { return }
        self.requestSoftWareDataList(keyWord: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("서치 취소 클릭")
        self.fetchSearchResult(cellType: .search)
    }
    
}

extension AppStoreSearchViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        cell.updateCellData(word: historyWordList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: mainSectionView) as! MainTVSectionView
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return mainSectionHeight
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return mainCellHeight
    }
}

extension AppStoreSearchViewController: UIScrollViewDelegate {
    //MARK: 투머치 자주 불림
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchingController.searchBar.endEditing(true)
    }
}
