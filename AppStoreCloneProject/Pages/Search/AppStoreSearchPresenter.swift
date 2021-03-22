//
//  AppStoreSearchPresenter.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit

protocol AppStoreSearchPresentationLogic {
    func presentHistoryWordList(response: AppStoreSearch.HistoryWord.Response)
    func presentSearchWordList(response: AppStoreSearch.SearchWord.Response)
    func presentError(error: Error?)
}

class AppStoreSearchPresenter: AppStoreSearchPresentationLogic {
    weak var viewController: AppStoreSearchDisplayLogic?
    
    // MARK: Do something
    
    func presentHistoryWordList(response: AppStoreSearch.HistoryWord.Response) {
        self.viewController?.displayHistoryWordList(viewModel: .init(historyWordList: response.historyWordList))
    }
    
    func presentSearchWordList(response: AppStoreSearch.SearchWord.Response) {
        self.viewController?.displaySearchWordList(viewModel: .init(iTunesSearchDataList: response.iTunesSearchDataList))
    }
    
    func presentError(error: Error?) {
        self.viewController?.displayError(error: error)
    }
}
