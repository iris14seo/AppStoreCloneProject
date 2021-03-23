//
//  SearchResultTableViewController.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/21.
//

import UIKit
import RxSwift
import RxCocoa

protocol SearchResultTableViewCellDelegate {
    func onClickHistoryCellForSearch(word: String)
    func didScrollSearchResultTableView()
}

class SearchResultTableViewController: RXTableViewController {

    let historyWordCell = "HistoryWordTableViewCell"
    let searchResultCell = "SearchResultTableViewCell"
    let notFoundCell = "NotFoundTableViewCell"
    
    //data
    var historyWordList: [String]?
    var searchDataList: [ResultTableViewCellData]?
    var currentResultType: AppStoreSearch.ResultType = .history
    var keyWord: String = ""
    
    var delegate: SearchResultTableViewCellDelegate?
    
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
            $0.backgroundColor = .yellow
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
            if let cell = tableView.dequeueReusableCell(withIdentifier: self.historyWordCell) as? HistoryWordTableViewCell {
                guard (self.historyWordList?.count ?? 0) > indexPath.row else {
                    return UITableViewCell()
                }
                cell.updateCellData(data: self.historyWordList?[indexPath.row])
                return cell
            }
        case .search:
            if let cell = tableView.dequeueReusableCell(withIdentifier: self.searchResultCell, for: indexPath) as? SearchResultTableViewCell {
                guard self.searchResultCell.count > indexPath.row else {
                    return UITableViewCell()
                }
                cell.updateCellData(data: self.searchDataList?[indexPath.row])
                return cell
            }
        case .notFound:
            if let cell = tableView.dequeueReusableCell(withIdentifier: self.notFoundCell, for: indexPath) as? NotFoundTableViewCell {
                cell.updateCellData(keyWord: self.keyWord)
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.currentResultType {
        case .history:
            return 40
        case .search:
            return 250
        case .notFound:
            return UITableView.automaticDimension
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch self.currentResultType {
        case .history:
            guard (self.historyWordList?.count ?? 0) > indexPath.row else {
                return
            }
            self.delegate?.onClickHistoryCellForSearch(word: self.historyWordList?[indexPath.row] ?? "")
        case .search:
            print("상세 페이지로 이동")
        case .notFound:
                break
        }
    }

    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.didScrollSearchResultTableView()
    }
}