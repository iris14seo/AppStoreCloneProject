//
//  AppStoreSearchWorker.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit
import RxSwift

class AppStoreSearchWorker: APIProtocol {
    
    var baseURLString: String = APIBaseURL.url
    var path: APIPath = .searchPath
    var queryParameters: [String : Any]?
    var method: HTTPMethod = .get
    
    let defaults = UserDefaults.standard
    let testUserDefaultArray: [String]? = ["카카오","카카오톡","카카오 뱅크","뱅크","카카오페이","카패","게임","애플","테스트","캌ㅋ","ㅋㅋㅇ","카카오택시","카톡","은행","배그","ㅁㅇㄹㅁ","하이","1","2","3","4","5","6","7","netflix","play"]
    
    //전체 최근 검색어 Array 가져오기
    func loadHistoryWordList() -> Observable<[String]?> {
        return Observable.create { (observer) -> Disposable in
            
            if let responseData = self.testUserDefaultArray { //self.defaults.array(forKey: "HistoryWordArray") as? [String]? {
                observer.onNext(responseData)
                observer.onCompleted()
            } else {
                observer.onError(RxError.noElements)
            }
            
            return Disposables.create()
        }
    }
    
    func requestItunesSearchList(keyWord: String) -> Observable<[ITunesSearchData]?> {
        return Observable.create { (observer) -> Disposable in
            
            self.queryParameters = [
                "country" : "kr",
                "media" : "music", //movie, podcast, music, musicVideo, audiobook, shortFilm, tvShow, software, ebook, all
                "limit" : 20
            ]
            self.queryParameters?["term"] = keyWord
            
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
