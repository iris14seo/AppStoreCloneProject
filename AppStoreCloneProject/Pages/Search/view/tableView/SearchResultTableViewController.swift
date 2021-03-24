//
//  SearchResultTableViewController.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/21.
//

import UIKit
import RxSwift
import RxCocoa

protocol SearchResultTVCellDelegate {
    func onClickHistoryCellForSearch(word: String)
    func hideSearchBarKeyBoard()
    func routeToDetailPage(index: Int)
}

class SearchResultTableViewController: RXTableViewController {

    let historyWordCell = "HistoryWordTVCell"
    let searchResultCell = "SearchResultTVCell"
    let notFoundCell = "NotFoundTVCell"
    
    let historyWordCellHeight: CGFloat = 50
    let searchResultCellHeight: CGFloat = 295
    let notFoundCellHeight: CGFloat = UIScreen.main.bounds.height  - 100
    
    //data
    var historyWordList: [String]?
    var searchDataList: [SoftWareCellDataModel]?
    var currentResultType: AppStoreSearch.ResultType = .history
    var keyWord: String = ""
    
    var delegate: SearchResultTVCellDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initStyle()
    }
    
    func initStyle() {
        self.view.do {
            $0.backgroundColor = .systemBackground
        }
        
        self.tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.separatorColor = .clear
            
            $0.register(UINib(nibName: historyWordCell, bundle: nil), forCellReuseIdentifier: historyWordCell)
            $0.register(UINib(nibName: searchResultCell, bundle: nil), forCellReuseIdentifier: searchResultCell)
            $0.register(UINib(nibName: notFoundCell, bundle: nil), forCellReuseIdentifier: notFoundCell)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.currentResultType {
        case .history:
            return self.historyWordList?.count ?? 0
        case .search:
            return self.searchDataList?.count ?? 0
        case .notFound:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.currentResultType {
        case .history:
            if let cell = tableView.dequeueReusableCell(withIdentifier: self.historyWordCell) as? HistoryWordTVCell {
                guard (self.historyWordList?.count ?? 0) > indexPath.row else {
                    return UITableViewCell()
                }
                cell.updateCellData(data: self.historyWordList?[indexPath.row])
                return cell
            }
        case .search:
            if let cell = tableView.dequeueReusableCell(withIdentifier: self.searchResultCell, for: indexPath) as? SearchResultTVCell {
                guard self.searchResultCell.count > indexPath.row else {
                    return UITableViewCell()
                }
                cell.updateCellData(data: self.searchDataList?[indexPath.row])
                return cell
            }
        case .notFound:
            if let cell = tableView.dequeueReusableCell(withIdentifier: self.notFoundCell, for: indexPath) as? NotFoundTVCell {
                cell.updateCellData(keyWord: self.keyWord)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.currentResultType {
        case .history:
            return historyWordCellHeight
        
        case .search:
            return searchResultCellHeight
        
        case .notFound:
            return notFoundCellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.hideSearchBarKeyBoard() // 이슈: 다른 방식으로 키보드 숨길 수 없을까?

        switch self.currentResultType {
        case .history:
            guard (self.historyWordList?.count ?? 0) > indexPath.row else {
                return
            }
            
            let keyWord = self.historyWordList?[indexPath.row] ?? ""
            self.keyWord = keyWord
            self.delegate?.onClickHistoryCellForSearch(word: keyWord)
        
        case .search:
            self.delegate?.routeToDetailPage(index: indexPath.row)
        
        case .notFound:
                break
        }
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.hideSearchBarKeyBoard()
    }
}
