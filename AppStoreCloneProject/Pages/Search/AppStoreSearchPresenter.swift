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
        self.viewController?.displaySearchWordList(viewModel: .init(softWareDataList: getResultTableViewCellDataList(dataList: response.softWareDataList)))
    }
    
    func presentError(error: Error?) {
        self.viewController?.displayError(error: error)
    }
    
    func getResultTableViewCellDataList(dataList: [SearchResultModel]?) -> [SoftWareCellData]? {
        
        //MARK: 임시 작업
        guard let dataList = dataList else {
            return nil
        }
        
        var cellDataList = [SoftWareCellData]()
        for data in dataList {
            var cellData = SoftWareCellData()
            cellData.title = data.trackName ?? "앱 이름"
            cellData.description = data.genres?.first ?? "설명"
            cellData.iconImageURL = data.artworkUrl60
            cellData.ratingScore = getRatingScore(originNum: data.averageUserRating)
            cellData.downloadCount = Int(data.userRatingCount ?? 0)
            cellData.downloadURL = data.trackViewUrl
            cellData.screenShotURLList = data.screenshotUrls
            cellDataList.append(cellData)
        }
        
        return cellDataList
    }
    
    func getRatingScore(originNum: Double?) -> Double {
        guard let originNum = originNum else {
            return 0.0
        }
        
        let numberFormatter = NumberFormatter()
        numberFormatter.roundingMode = .floor
        numberFormatter.minimumSignificantDigits = 0
        numberFormatter.maximumSignificantDigits = 1

        return Double(numberFormatter.string(from: NSNumber(value: originNum)) ?? "") ?? 0.0
    }
}
