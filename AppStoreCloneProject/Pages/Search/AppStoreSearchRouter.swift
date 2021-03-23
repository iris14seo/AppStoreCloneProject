//
//  AppStoreSearchRouter.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit

@objc protocol AppStoreSearchRoutingLogic {
    func routeToMemoDetailPage(index: Int)
}

protocol AppStoreSearchDataPassing {
    var dataStore: AppStoreSearchDataStore? { get }
}

class AppStoreSearchRouter: NSObject, AppStoreSearchRoutingLogic, AppStoreSearchDataPassing {
    weak var viewController: AppStoreSearchViewController?
    var dataStore: AppStoreSearchDataStore?
    
    // MARK: Routing
    
    func routeToMemoDetailPage(index: Int) {
        let destinationVC = AppStoreDetailPage()
        var destinationDS = destinationVC.router!.dataStore!
        passDataToDetail(index: index, source: dataStore!, destination: &destinationDS)
        navigateToDetail(departure: viewController!, destination: destinationVC)
    }
    
    // MARK: Navigation
    func navigateToDetail(departure: AppStoreSearchPage, destination: AppStoreDetailPage) {
        departure.navigationController?.pushViewController(destination, animated: true)
    }
    
    // MARK: Passing data
    func passDataToDetail(index: Int, source: AppStoreSearchDataStore, destination: inout AppStoreDetailDataStore) {
        destination.softWareData = source.softWareDataList?[index]
    }
}
