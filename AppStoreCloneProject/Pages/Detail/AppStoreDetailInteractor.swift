//
//  AppStoreDetailInteractor.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit

protocol AppStoreDetailBusinessLogic {
    //func doSomething(request: AppStoreDetail.Something.Request)
}

protocol AppStoreDetailDataStore {
    //var name: String { get set }
}

class AppStoreDetailInteractor: AppStoreDetailBusinessLogic, AppStoreDetailDataStore
{
    var presenter: AppStoreDetailPresentationLogic?
    var worker: AppStoreDetailWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    //  func doSomething(request: AppStoreDetail.Something.Request) {
    //    worker = AppStoreDetailWorker()
    //    worker?.doSomeWork()
    //
    //    let response = AppStoreDetail.Something.Response()
    //    presenter?.presentSomething(response: response)
    //  }
}
