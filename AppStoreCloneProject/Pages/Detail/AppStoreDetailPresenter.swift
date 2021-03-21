//
//  AppStoreDetailPresenter.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit

protocol AppStoreDetailPresentationLogic {
    //func presentSomething(response: AppStoreDetail.Something.Response)
}

class AppStoreDetailPresenter: AppStoreDetailPresentationLogic {
    weak var viewController: AppStoreDetailDisplayLogic?
    
    // MARK: Do something
    
    //    func presentSomething(response: AppStoreDetail.Something.Response) {
    //        let viewModel = AppStoreDetail.Something.ViewModel()
    //        viewController?.displaySomething(viewModel: viewModel)
    //    }
}
