//
//  AppStoreDetailPresenter.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit

protocol AppStoreDetailPresentationLogic {
    func presentFetchDetailData(response: AppStoreDetail.FetchData.Response)
}

class AppStoreDetailPresenter: AppStoreDetailPresentationLogic {
    weak var viewController: AppStoreDetailDisplayLogic?
    
    // MARK: Do something
    
    func presentFetchDetailData(response: AppStoreDetail.FetchData.Response) {
        viewController?.displayDetailData(viewModel: .init(data: response.data))
    }
}
