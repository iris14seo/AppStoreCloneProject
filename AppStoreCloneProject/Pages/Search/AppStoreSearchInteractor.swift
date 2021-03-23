//
//  AppStoreSearchInteractor.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit
import RxSwift

protocol AppStoreSearchBusinessLogic {
    func loadAllHistoryWordList(request: AppStoreSearch.HistoryWord.Request)
    func loadHistoryWordList(request: AppStoreSearch.HistoryWord.Request)
    func requestSearchWordList(request: AppStoreSearch.SearchWord.Request)
}

protocol AppStoreSearchDataStore {
    var softWareDataList: [SearchResultModel]? { get set }
}

class AppStoreSearchInteractor: AppStoreSearchBusinessLogic, AppStoreSearchDataStore {
    var presenter: AppStoreSearchPresentationLogic?
    var worker = AppStoreSearchWorker()
    
    var historyWordList: [String]?
    var softWareDataList: [SearchResultModel]?
    
    let disposeBag = DisposeBag()
    /*
     //MARK: [도전과제] API 기반 검색에 'paging 처리 기능 추가' 가능해지면 작업할 것
     var pageIndex: Int = 0
     let pageSize: Int = defaultPageSize
     */
    
    // MARK: Do something
    
    func loadAllHistoryWordList(request: AppStoreSearch.HistoryWord.Request) {
        
        self.worker.loadHistoryWordList().asObservable()
            .subscribe(onNext: { response in
                self.historyWordList = response
                
                var response = AppStoreSearch.HistoryWord.Response(target: request.target)
                response.historyWordList = self.historyWordList
                
                self.presenter?.presentHistoryWordList(response: response)
                
            }, onError: { [weak self] (error) in
                self?.presenter?.presentError(error: error)
            }).disposed(by: self.disposeBag)
        
    }
    
    func loadHistoryWordList(request: AppStoreSearch.HistoryWord.Request) {
        
        self.worker.loadHistoryWordList().asObservable()
            .subscribe(onNext: { response in
                self.historyWordList = response
                
                var response = AppStoreSearch.HistoryWord.Response(target: request.target)
                if let filterWord = request.keyWord {
                    response.historyWordList = self.historyWordList?.filter{ $0.lowercased().contains(filterWord) }
                }
                
                self.presenter?.presentHistoryWordList(response: response)
                
            }, onError: { [weak self] (error) in
                self?.presenter?.presentError(error: error)
            }).disposed(by: self.disposeBag)
        
    }
    
    func requestSearchWordList(request: AppStoreSearch.SearchWord.Request) {
        self.worker.requestSoftWareDataList(keyWord: request.keyWord).asObservable()
            .subscribe(onNext: { [weak self] (result) in
                
                self?.softWareDataList = result
                self?.presenter?.presentSearchWordList(response: .init(softWareDataList: self?.softWareDataList))
                
            }, onError: { [weak self] (error) in
                self?.presenter?.presentError(error: error)
            }).disposed(by: self.disposeBag)
    }
    
}
