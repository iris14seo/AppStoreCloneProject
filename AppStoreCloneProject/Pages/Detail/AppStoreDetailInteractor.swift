//
//  AppStoreDetailInteractor.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit

protocol AppStoreDetailBusinessLogic {
    func fetchDetailData()
}

protocol AppStoreDetailDataStore {
    var softWareData: SoftwareDataModel? { get set }
}

class AppStoreDetailInteractor: AppStoreDetailBusinessLogic, AppStoreDetailDataStore {
    var presenter: AppStoreDetailPresentationLogic?
    var worker: AppStoreDetailWorker?
    
    var softWareData: SoftwareDataModel?
    
    // MARK: Do something
    
    func fetchDetailData() {
        self.presenter?.presentFetchDetailData(response: AppStoreDetail.FetchData.Response(data: self.softWareData))
    }
}
