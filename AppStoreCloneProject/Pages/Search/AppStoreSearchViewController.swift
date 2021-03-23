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
        
        self.loadAllHistoryWord()
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
        }
        
        return sc
    }()
    
    //tableView
    let mainCell = "MainTableViewCell"
    let mainCellHeight: CGFloat = 40
    
    let mainSectionView: String = "MainTableViewSectionView"
    let mainSectionHeight: CGFloat = 45.0
    
    @IBOutlet var mainTableView: UITableView!
    
    //data
    var vmHistoryWordList: [String]?
    
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
    
    @objc func handleSwipeGesture() {
        self.view.endEditing(true)
    }
    
    func loadAllHistoryWord() {
        self.interactor?.loadAllHistoryWordList(request: .init(target: .main))
    }
    
    func loadHistoryWord(target: AppStoreSearch.HistoryWord.TargetTableView, keyWord: String? = nil) {
        self.interactor?.loadHistoryWordList(request: .init(target: target, keyWord: keyWord))
        self.updateSearchWordType(type: .history)
    }
    
    func requestSoftWareDataList(keyWord: String) {
        self.interactor?.requestSearchWordList(request: .init(keyWord: keyWord))
        self.updateSearchWordType(type: .search)
    }
    
    func displayHistoryWordList(viewModel: AppStoreSearch.HistoryWord.ViewModel) {
        guard let historyWordList = viewModel.historyWordList else {
            return
        }
        
        switch viewModel.target {
        case .main:
            self.updateHistoryWordTableView(dataList: historyWordList)
        case .search:
            self.updateSearchWordTableView(dataList: historyWordList, type: .history)
        }
        
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
    
    func updateHistoryWordTableView(dataList: [String]?) {
        dump(dataList)
        
        self.vmHistoryWordList = dataList
        self.mainTableView.reloadData()
    }
    
    func updateSearchWordTableView(dataList: [Any]?, type: AppStoreSearch.ResultType) {
        dump(dataList)
        
        if (dataList?.count ?? 0) > 0 {
            
            if type == .history {
                let historyList = dataList as? [String]
                self.searchResultTableViewController.historyWordList = historyList
            } else if type == .search {
                let searchList = dataList as? [SoftWareCellData]
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
}

extension AppStoreSearchViewController: SearchResultTableViewCellDelegate {
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
        
        self.loadHistoryWord(target: .search, keyWord: text)
    }
}

extension AppStoreSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            self.loadHistoryWord(target: .search)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text.isEmpty {
            self.loadHistoryWord(target: .search)
        }
        
        return true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        print("서치 버튼 클릭")
        
        guard let text = searchBar.text, text.count > 0 else { return }
        self.searchingController.searchBar.endEditing(true)
        self.requestSoftWareDataList(keyWord: text)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("서치 취소 클릭")
        
        self.loadHistoryWord(target: .search)
    }
    
}

extension AppStoreSearchViewController: UITableViewDelegate, UITableViewDataSource {
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let historyWordList = self.vmHistoryWordList,
              !historyWordList.isEmpty else {
            return 0
        }
                
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
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: mainSectionView) as! MainTableViewSectionView
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
