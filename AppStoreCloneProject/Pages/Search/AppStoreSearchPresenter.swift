//
//  AppStoreSearchPresenter.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit

protocol AppStoreSearchPresentationLogic {
    func presentAllHistoryWordList(response: AppStoreSearch.AllHistoryWord.Response)
    func presentFilteredHistoryWordList(response: AppStoreSearch.FilteredHistoryWord.Response)
    func presentSearchWordList(response: AppStoreSearch.SearchWord.Response)
    func presentError(error: Error?)
}

class AppStoreSearchPresenter: AppStoreSearchPresentationLogic {
    weak var viewController: AppStoreSearchDisplayLogic?
    
    private let screenShotMaxImageCount = 3
    
    // MARK: Do something
    
    func presentAllHistoryWordList(response: AppStoreSearch.AllHistoryWord.Response) {
        self.viewController?.displayAllHistoryWordList(viewModel: .init(historyWordList: response.historyWordList))
    }
    
    func presentFilteredHistoryWordList(response: AppStoreSearch.FilteredHistoryWord.Response) {
        self.viewController?.displayFilteredHistoryWordList(viewModel: .init(historyWordList: response.historyWordList))
    }
    
    func presentSearchWordList(response: AppStoreSearch.SearchWord.Response) {
        self.viewController?.displaySearchWordList(viewModel: .init(softWareDataList: getResultTableViewCellDataList(dataList: response.softWareDataList)))
    }
    
    func presentError(error: Error?) {
        self.viewController?.displayError(error: error)
    }
    
    func getResultTableViewCellDataList(dataList: [SearchResultModel]?) -> [SoftWareCellDataModel]? {
        
        guard let dataList = dataList else {
            return nil
        }
        
        var cellDataList = [SoftWareCellDataModel]()
        for data in dataList {
            var cellData = SoftWareCellDataModel()
            cellData.title = data.trackName ?? "앱 이름"
            cellData.description = data.genres?.first ?? "설명"
            cellData.iconImageURL = data.artworkUrl60
            cellData.ratingScore = getRatingScore(originNum: data.averageUserRating)
            cellData.downloadCount = Int(data.userRatingCount ?? 0)
            cellData.downloadURL = data.trackViewUrl
            cellData.screenShotURLList = self.getScreenShotUrlStringList(list: data.screenshotUrls)
            cellDataList.append(cellData)
        }
        
        return cellDataList
    }
    
    func getScreenShotUrlStringList(list: [String]?) -> [String]? {
        guard let imageList = list, (list?.count ?? 0) > screenShotMaxImageCount else {
            return list
        }
        
        var urlStringList = [String]()
        for item in imageList[..<screenShotMaxImageCount] {
            urlStringList.append(item)
        }
        return urlStringList
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
