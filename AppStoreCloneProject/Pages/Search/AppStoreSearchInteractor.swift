//
//  AppStoreSearchInteractor.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit
import RxSwift

protocol AppStoreSearchBusinessLogic {
    func loadAllHistoryWordList(request: AppStoreSearch.AllHistoryWord.Request)
    func loadFilteredHistoryWordList(request: AppStoreSearch.FilteredHistoryWord.Request)
    func requestSearchWordList(request: AppStoreSearch.SearchWord.Request)
}

protocol AppStoreSearchDataStore {
    var softWareDataList: [SoftwareDataModel]? { get set }
}

class AppStoreSearchInteractor: AppStoreSearchBusinessLogic, AppStoreSearchDataStore {
    var presenter: AppStoreSearchPresentationLogic?
    var worker = AppStoreSearchWorker()
    
    var historyWordList: [String]?
    var softWareDataList: [SoftwareDataModel]?
    
    let disposeBag = DisposeBag()
    
    // MARK: Do something
    
    func loadAllHistoryWordList(request: AppStoreSearch.AllHistoryWord.Request) {
        
        self.worker.loadHistoryWordList().asObservable()
            .subscribe(onNext: { response in
                self.historyWordList = response
                self.presenter?.presentAllHistoryWordList(response: .init(historyWordList: response))
            }, onError: { [weak self] (error) in
                self?.presenter?.presentError(error: error)
            }).disposed(by: self.disposeBag)

    }
    
    func loadFilteredHistoryWordList(request: AppStoreSearch.FilteredHistoryWord.Request) {
        
        self.worker.loadHistoryWordList().asObservable()
            .subscribe(onNext: { response in
                self.historyWordList = response
                
                var response = AppStoreSearch.FilteredHistoryWord.Response()
                if let filterWord = request.keyWord {
                    response.historyWordList = self.historyWordList?.filter{ $0.lowercased().contains(filterWord.lowercased()) }
                } else {
                    response.historyWordList = nil
                }
                
                self.presenter?.presentFilteredHistoryWordList(response: response)
                
            }, onError: { [weak self] (error) in
                self?.presenter?.presentError(error: error)
            }).disposed(by: self.disposeBag)
        
    }
    
    func requestSearchWordList(request: AppStoreSearch.SearchWord.Request) {
        
        self.updateHistoryWordUserDefault(keyWord: request.keyWord)
        
        self.worker.requestSoftWareDataList(keyWord: request.keyWord).asObservable()
            .subscribe(onNext: { [weak self] (result) in
                
                self?.softWareDataList = result
                self?.presenter?.presentSearchWordList(response: .init(softWareDataList: result))
                
            }, onError: { [weak self] (error) in
                self?.presenter?.presentError(error: error)
            }).disposed(by: self.disposeBag)
    }
    
    private func updateHistoryWordUserDefault(keyWord: String) {
        HistoryWordUserDefaultManager.shared.addData(word: keyWord)
    }
}
