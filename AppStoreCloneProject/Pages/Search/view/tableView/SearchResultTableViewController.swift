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
    func onClickHistoryCellForSearch(keyWord: String)
    func hideSearchBarKeyBoard()
    func routeToDetailPage(index: Int)
}

class SearchResultTableViewController: RXTableViewController {

    let historyWordCell = "HistoryWordTVCell"
    let searchResultCell = "SearchResultTVCell"
    let notFoundCell = "NotFoundTVCell"
    
    let historyWordCellHeight: CGFloat = 50.0
    let searchResultCellHeight: CGFloat = 295.0
    let notFoundCellHeight: CGFloat = UIScreen.main.bounds.height - 100
    
    //data
    var historyWordList: [String]?
    var searchDataList: [SoftWareCellDataModel]?
    var currentResultType: AppStoreSearch.ResultType = .localHistory
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
        case .localHistory:
            return self.historyWordList?.count ?? 0
        case .apiSearch:
            return self.searchDataList?.count ?? 0
        case .noResult:
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch self.currentResultType {
        case .localHistory:
            if let cell = tableView.dequeueReusableCell(withIdentifier: self.historyWordCell) as? HistoryWordTVCell {
                guard (self.historyWordList?.count ?? 0) > indexPath.row else {
                    return UITableViewCell()
                }
                cell.updateCellData(data: self.historyWordList?[indexPath.row])
                return cell
            }
        case .apiSearch:
            if let cell = tableView.dequeueReusableCell(withIdentifier: self.searchResultCell, for: indexPath) as? SearchResultTVCell {
                guard (self.searchDataList?.count ?? 0) > indexPath.row else {
                    return UITableViewCell()
                }
                cell.updateCellData(data: self.searchDataList?[indexPath.row])
                return cell
            }
        case .noResult:
            if let cell = tableView.dequeueReusableCell(withIdentifier: self.notFoundCell, for: indexPath) as? NotFoundTVCell {
                cell.updateCellData(keyWord: self.keyWord)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.currentResultType {
        case .localHistory:
            return historyWordCellHeight
        
        case .apiSearch:
            return searchResultCellHeight
        
        case .noResult:
            return notFoundCellHeight
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.hideSearchBarKeyBoard()
        
        switch self.currentResultType {
        case .localHistory:
            guard (self.historyWordList?.count ?? 0) > indexPath.row else {
                return
            }
            
            let keyWord = self.historyWordList?[indexPath.row] ?? ""
            self.keyWord = keyWord
            self.delegate?.onClickHistoryCellForSearch(keyWord: keyWord)
        
        case .apiSearch:
            self.delegate?.routeToDetailPage(index: indexPath.row)
        
        case .noResult:
                break
        }
    }
}
