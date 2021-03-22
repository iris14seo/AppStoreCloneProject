//
//  SearchResultTableViewController.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/21.
//

import UIKit

//MARK: test 코드
class SearchResultTableViewController: UITableViewController {

    let recentWordReuseIdentifier = "RecentWordTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initStyle()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func initStyle() {
        self.view.do {
            $0.backgroundColor = .red
        }
        
        self.tableView.do {
            $0.delegate = self
            $0.dataSource = self
            $0.register(UINib(nibName: recentWordReuseIdentifier, bundle: nil), forCellReuseIdentifier: recentWordReuseIdentifier)
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 3
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.recentWordReuseIdentifier, for: indexPath) as! RecentWordTableViewCell
        cell.backgroundColor = .red
        return cell
    }

}
