//
//  AppStoreSearchWorker.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit
import RxSwift

class AppStoreSearchWorker: APIProtocol {
    
    enum ParameterEntity: String {
        case movie, podcast, music, musicVideo, audiobook, shortFilm, tvShow, software, ebook, all
    }
    
    let parameterLimit = 20
    
    var baseURLString: String = APIBaseURL.url
    var path: APIPath = .searchPath
    var queryParameters: [String : Any]?
    var method: HTTPMethod = .get
    
    /**UserDefault에서 최근 검색어목록 가져오기
     */
    func loadHistoryWordList() -> Observable<[String]?> {
        return Observable.create { (observer) -> Disposable in
            
            if let responseData = HistoryWordUserDefaultManager.shared.getWordList() {
                observer.onNext(responseData)
                observer.onCompleted()
            } else {
                observer.onError(RxError.noElements)
            }
            
            return Disposables.create()
        }
    }
    
    /**최근검색 추가 여부에 따른 목록 재구성
     */
    func historyWordFilterList(wordList:[String], tapIndex:Int) -> [String] {
        var resultWordList:[String] = wordList
        if tapIndex == 1 {
            resultWordList = wordList.filter({
                return HistoryWordUserDefaultManager.shared.isExistWord(word: $0)
            })
        }
        return resultWordList
    }
    
    /**iTunes Search API에서 검색결과 조회
     */
    func requestSoftWareDataList(keyWord: String) -> Observable<[SearchResultModel]?> {
        return Observable.create { (observer) -> Disposable in
            
            self.queryParameters = [
                "country" : "kr",
                "entity" : ParameterEntity.software.rawValue,
                "limit" : self.parameterLimit,
                "term" : keyWord
            ]
            
            NetworkManager.shared.requestJSON(self.baseURLString, path: self.path, queryParameters: self.queryParameters, method: self.method, completionHandler: { (response) in
                switch response {
                case .success(result: let data):
                    observer.onNext(data)
                    observer.onCompleted()
                case .failure(error: let error):
                    observer.onError(error)
                }
                
            })
            return Disposables.create()
        }
    }
}

//MARK: test code
//let testUserDefaultArray: [String]? = ["카카오","카카오톡","카카오 뱅크","뱅크","카카오페이","카패","게임","애플","테스트","캌ㅋ","ㅋㅋㅇ","카카오택시","카톡","은행","배그","ㅁㅇㄹㅁ","하이","1","2","3","4","5","6","7","netflix","play"]
