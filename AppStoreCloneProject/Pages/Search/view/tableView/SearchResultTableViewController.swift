//
//  SearchResultTableViewController.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/21.
//

import UIKit
import RxSwift
import RxCocoa

class SearchResultTableViewController: RXTableViewController {

    let historyWordCell = "HistoryWordTableViewCell"
    let searchResultCell = "SearchResultTableViewCell"
    let notFoundCell = "NotFoundTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initStyle()
    }
    
    func initStyle() {
        self.view.do {
            $0.backgroundColor = .red
        }
        
        self.tableView.do {
            $0.delegate = self
            $0.dataSource = self
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
        return 7
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.historyWordCell, for: indexPath) as! HistoryWordTableViewCell
        cell.backgroundColor = .lightGray
        return cell
    }

}
