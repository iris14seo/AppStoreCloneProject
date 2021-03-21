//
//  AppStoreSearchPresenter.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit

protocol AppStoreSearchPresentationLogic {
    //func presentSomething(response: AppStoreSearch.Something.Response)
}

class AppStoreSearchPresenter: AppStoreSearchPresentationLogic {
    weak var viewController: AppStoreSearchDisplayLogic?
    
    // MARK: Do something
    
    //    func presentSomething(response: AppStoreSearch.Something.Response) {
    //        let viewModel = AppStoreSearch.Something.ViewModel()
    //        viewController?.displaySomething(viewModel: viewModel)
    //    }
}
