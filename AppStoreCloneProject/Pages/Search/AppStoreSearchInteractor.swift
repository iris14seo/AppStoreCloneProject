//
//  AppStoreSearchInteractor.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit
import RxSwift

protocol AppStoreSearchBusinessLogic {
    func updateSearchTableViewType(type: AppStoreSearch.ResultType)
    func loadHistoryWordList(request: AppStoreSearch.HistoryWord.Request)
    func requestSearchWordList(request: AppStoreSearch.SearchWord.Request)
}

protocol AppStoreSearchDataStore {
    var searchTableViewResultType: AppStoreSearch.ResultType { get set }
    var historyWordList: [String]? { get set }
    var softWareDataList: [SearchResultModel]? { get set } //MARK: [도전과제] 음악말고 다양한 DataModel 추가하면 'var searchedDataList: [Any]? { get set }' 로 변경하기
}

class AppStoreSearchInteractor: AppStoreSearchBusinessLogic, AppStoreSearchDataStore {
    var presenter: AppStoreSearchPresentationLogic?
    var worker = AppStoreSearchWorker()
    
    var searchTableViewResultType: AppStoreSearch.ResultType = .history
    var historyWordList: [String]?
    var softWareDataList: [SearchResultModel]?
    
    let disposeBag = DisposeBag()
    /*
     //MARK: [도전과제] API 기반 검색에 'paging 처리 기능 추가' 가능해지면 작업할 것
     var pageIndex: Int = 0
     let pageSize: Int = defaultPageSize
     */
    
    // MARK: Do something
    
    func updateSearchTableViewType(type: AppStoreSearch.ResultType) {
        self.searchTableViewResultType = type
    }
    
    func loadHistoryWordList(request: AppStoreSearch.HistoryWord.Request) {
        
        self.worker.loadHistoryWordList().asObservable()
            .subscribe(onNext: { response in
                self.historyWordList = response
                
                var response = AppStoreSearch.HistoryWord.Response(target: request.target)
                if let filterWord = request.keyWord {
                    response.historyWordList = self.historyWordList?.filter{ $0.lowercased().contains(filterWord) }
                } else {
                    response.historyWordList = self.historyWordList
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
