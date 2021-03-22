//
//  AppStoreSearchInteractor.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit
import RxSwift

protocol AppStoreSearchBusinessLogic {
    func loadRecentWordList(request: AppStoreSearch.RecentWord.Request)
    func requestSearchWordList(request: AppStoreSearch.SearchWord.Request)
}

protocol AppStoreSearchDataStore {
    var storedRecentWordList: [String]? { get set }
    var musicDataList: [MusicData]? { get set } //MARK: [도전과제] 음악말고 다양한 DataModel 추가하면 'var searchedDataList: [Any]? { get set }' 로 변경하기
}

class AppStoreSearchInteractor: AppStoreSearchBusinessLogic, AppStoreSearchDataStore {
    var presenter: AppStoreSearchPresentationLogic?
    var worker = AppStoreSearchWorker()
    var storedRecentWordList: [String]?
    var musicDataList: [MusicData]?
    
    let disposeBag = DisposeBag()
    /*
     //MARK: [도전과제] API 기반 검색에 'paging 처리 기능 추가' 가능해지면 작업할 것
     var pageIndex: Int = 0
     let pageSize: Int = defaultPageSize
     */
    
    // MARK: Do something
    
    func loadRecentWordList(request: AppStoreSearch.RecentWord.Request) {
        
        self.worker.loadRecentWordList().asObservable()
            .subscribe(onNext: { response in
                self.storedRecentWordList = response
                
                var response = AppStoreSearch.RecentWord.Response()
                if let filterWord = request.keyWord {
                    response.recentWordList = self.storedRecentWordList?.filter{ $0.lowercased().contains(filterWord) }
                } else {
                    response.recentWordList = self.storedRecentWordList
                }
                
                self.presenter?.presentRecentWordList(response: response)
                
            }, onError: { [weak self] (error) in
                guard let error = error as? APIError else {
                    return
                }
                
                self?.presenter?.presentError(error: error)
            }).disposed(by: self.disposeBag)
        
    }
    
    func requestSearchWordList(request: AppStoreSearch.SearchWord.Request) {
        
        self.worker.requestMusicDataList(keyWord: request.keyWord).asObservable()
            .subscribe(onNext: { response in
                self.musicDataList = response
                
                self.presenter?.presentSearchWordList(response: .init(musicDataList: self.musicDataList))
            }, onError: { [weak self] (error) in
                guard let error = error as? APIError else {
                    return
                }
                
                self?.presenter?.presentError(error: error)
            }).disposed(by: self.disposeBag)
    }
}
//    func loadAllRecentWordList() {
//        var disposable: Disposable?
//
//        disposable = self.worker?.requestListItems(pageIndex: index, pageSize: self.pageSize)
//            .subscribe( onNext: { data in
//                disposable?.dispose()
//
//                self.pageIndex = index
//
//                if self.listItems == nil, request.pageType == .first {
//                    self.listItems = []
//                }
//
//                self.listItems?.append(data.items)
//
//                self.presenter?.presentListItems(response: .init(listData: data))
//
//            }, onError: { error in
//
//                disposable?.dispose()
//
//                self.presenter?.presentListItemsLoadingError(response: .init(error: error))
//            })
//    }
