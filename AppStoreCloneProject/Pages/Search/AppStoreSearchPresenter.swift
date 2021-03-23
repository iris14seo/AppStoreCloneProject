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
        self.viewController?.displayHistoryWordList(viewModel: .init(target: response.target, historyWordList: response.historyWordList))
    }
    
    func presentSearchWordList(response: AppStoreSearch.SearchWord.Response) {
        self.viewController?.displaySearchWordList(viewModel: .init(iTunesSearchDataList: getResultTableViewCellDataList(dataList: response.iTunesSearchDataList)))
    }
    
    func presentError(error: Error?) {
        self.viewController?.displayError(error: error)
    }
    
    func getResultTableViewCellDataList(dataList: [ITunesSearchData]?) -> [ResultTableViewCellData]? {
        
        //MARK: 임시 작업
        guard let dataList = dataList else {
            return nil
        }
        
        var cellDataList = [ResultTableViewCellData]()
        for data in dataList {
            var cellData = ResultTableViewCellData()
            cellData.wrapperType = data.wrapperType
            cellData.title = data.artistName ?? ""
            cellData.description = data.collectionName
            cellData.iconImageURL = data.previewURL
            cellData.ratingScore = Double(data.discNumber ?? 0)
            cellData.downloadCount = data.discCount
            cellData.downloadURL = data.artistViewURL
            cellData.bottomImageURLList = [data.collectionViewURL ?? ""]
            cellDataList.append(cellData)
        }
        
        return cellDataList
    }
}
