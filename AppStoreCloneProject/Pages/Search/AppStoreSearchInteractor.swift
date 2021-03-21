//
//  AppStoreSearchInteractor.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit

protocol AppStoreSearchBusinessLogic {
    //func doSomething(request: AppStoreSearch.Something.Request)
}

protocol AppStoreSearchDataStore {
    //var name: String { get set }
}

class AppStoreSearchInteractor: AppStoreSearchBusinessLogic, AppStoreSearchDataStore
{
    var presenter: AppStoreSearchPresentationLogic?
    var worker: AppStoreSearchWorker?
    //var name: String = ""
    
    // MARK: Do something
    
    //  func doSomething(request: AppStoreSearch.Something.Request) {
    //    worker = AppStoreSearchWorker()
    //    worker?.doSomeWork()
    //
    //    let response = AppStoreSearch.Something.Response()
    //    presenter?.presentSomething(response: response)
    //  }
}
