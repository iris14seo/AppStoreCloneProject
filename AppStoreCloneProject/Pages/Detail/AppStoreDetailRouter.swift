//
//  AppStoreDetailRouter.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit

@objc protocol AppStoreDetailRoutingLogic {
}

protocol AppStoreDetailDataPassing {
    var dataStore: AppStoreDetailDataStore? { get }
}

class AppStoreDetailRouter: NSObject, AppStoreDetailRoutingLogic, AppStoreDetailDataPassing {
    weak var viewController: AppStoreDetailViewController?
    var dataStore: AppStoreDetailDataStore?
    
    // MARK: Routing
    
}
