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
    
    private let screenShotMaxImageCount = 5

    // MARK: Do something
    
    func presentFetchDetailData(response: AppStoreDetail.FetchData.Response) {

        guard let data = response.data else {
            return
        }
        var model = AppStoreDetail.SoftWareDetailDataModel()
        model.title = data.trackName
        model.genres = data.genres?.first
        model.iconImageURL = data.artworkUrl100
        model.downloadURL = data.trackViewUrl
        model.ratingScore = data.averageUserRating ?? 0
        model.downloadCount = Int(data.userRatingCount ?? 0).downloadUnit
        model.recommenedAge = data.contentAdvisoryRating
        model.baseLanguage = data.languageCodesISO2A?.first
        model.minimumOsVersion = data.minimumOsVersion
        model.screenShotURLList = self.getScreenShotUrlStringList(list: data.screenshotUrls)
        model.supportedDevices = self.getSupportedDevices(list: data.supportedDevices)
        model.longDescription = data.description
        model.developerID = data.sellerName
        
        viewController?.displayDetailData(viewModel: .init(data: model))
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
    
    func getSupportedDevices(list: [String]?) -> [AppStoreDetail.SupportedDevice]?  {
        guard let deviceList = list, deviceList.count > 0 else {
            return nil
        }
        
        var supportedDeviceList = [AppStoreDetail.SupportedDevice]()
        if deviceList.filter({$0.hasPrefix("iPhone")}).count > 0 {
            supportedDeviceList.append(AppStoreDetail.SupportedDevice.iPhone)
        }
        
        if deviceList.filter({$0.hasPrefix("iPad")}).count > 0 {
            supportedDeviceList.append(AppStoreDetail.SupportedDevice.iPad)
        }
        
        return supportedDeviceList
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
