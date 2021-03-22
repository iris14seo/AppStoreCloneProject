//
//  AppStoreSearchPresenter.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit

protocol AppStoreSearchPresentationLogic {
    func presentRecentWordList(response: AppStoreSearch.RecentWord.Response)
    func presentSearchWordList(response: AppStoreSearch.SearchWord.Response)
    func presentError(error: APIError?)
}

class AppStoreSearchPresenter: AppStoreSearchPresentationLogic {
    weak var viewController: AppStoreSearchDisplayLogic?
    
    // MARK: Do something
    
    func presentRecentWordList(response: AppStoreSearch.RecentWord.Response) {
        self.viewController?.displayRecentWordList(viewModel: .init(recentWordList: response.recentWordList))
    }
    
    func presentSearchWordList(response: AppStoreSearch.SearchWord.Response) {
        self.viewController?.displaySearchWordList(viewModel: .init(musicDataList: response.musicDataList))
    }
    
    func presentError(error: APIError?) {
        self.viewController?.displayError(error: error)
    }
}
