//
//  AppStoreSearchRouter.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit

@objc protocol AppStoreSearchRoutingLogic {
    //func routeToSomewhere(segue: UIStoryboardSegue?)
}

protocol AppStoreSearchDataPassing {
    var dataStore: AppStoreSearchDataStore? { get }
}

class AppStoreSearchRouter: NSObject, AppStoreSearchRoutingLogic, AppStoreSearchDataPassing {
    weak var viewController: AppStoreSearchViewController?
    var dataStore: AppStoreSearchDataStore?
    
    // MARK: Routing
    
    //func routeToSomewhere(segue: UIStoryboardSegue?)
    //{
    //  if let segue = segue {
    //    let destinationVC = segue.destination as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //  } else {
    //    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    //    let destinationVC = storyboard.instantiateViewController(withIdentifier: "SomewhereViewController") as! SomewhereViewController
    //    var destinationDS = destinationVC.router!.dataStore!
    //    passDataToSomewhere(source: dataStore!, destination: &destinationDS)
    //    navigateToSomewhere(source: viewController!, destination: destinationVC)
    //  }
    //}
    
    // MARK: Navigation
    
    //func navigateToSomewhere(source: AppStoreSearchViewController, destination: SomewhereViewController)
    //{
    //  source.show(destination, sender: nil)
    //}
    
    // MARK: Passing data
    
    //func passDataToSomewhere(source: AppStoreSearchDataStore, destination: inout SomewhereDataStore)
    //{
    //  destination.name = source.name
    //}
}
