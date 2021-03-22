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
    func loadRecentWordList() -> Observable<[String]?> {
        return Observable.create { (observer) -> Disposable in
            
            if let responseData = self.testUserDefaultArray { //self.defaults.array(forKey: "StoredRecentWordArray") as? [String]? {
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
    
    //'검색어'로 API 검색하기
    /*func requestMusicDataList(keyWord: String) -> Observable<[MusicData]?> {
        return Observable.create { (observer) -> Disposable in
            
            MusicAPIManager.shared.getMusicDataList(keyWord: keyWord, completionHandler: { result in
                
                switch result {
                case .success(let musicDataList):
                    observer.onNext(musicDataList)
                    observer.onCompleted()
                    
                case .failure(let error):
                    //print(error.localizedDescription)
                    observer.onError(error) //MARK: [고민] 어떻게 핸들링 하지..?
                }
                
            })
            return Disposables.create()
        }
    }*/

}

/*
 
 //            MusicAPIManager.shared.getMusicDataList(keyWord: keyWord, completionHandler: {(response) in
 //                let response = response as? APIResult<[MusicData]?>
 //                if let musicDataArray = response
 //                } else {
 //                }
 //            })
 //
 //
 //                if error != nil {
 //                    observer.onError(RxError.noElements)
 //                } else {
 //                    observer.onNext(musicDataList)
 //                    observer.onCompleted()
 //                }
 //            }
 //            return Disposables.create()

 
 ///////////////
 public func loadAllCoinList() -> Observable<[CoinData]?>{
 return Observable.create { (observer) -> Disposable in
 
 ApiManager.shared.getCoinList { (coinList) in
 observer.onNext(coinList)
 observer.onCompleted()
 }
 return Disposables.create()
 }
 }
 
 //입력된 단어로 API 검색하기
 // 비트코인 정보를 가져옴
 public func loadBTCCoin() -> Observable<CoinData?>{
 return Observable.create {​​​ (observer) -> Disposable in
 
 ApiManager.shared.getCoinByCurrency(currency: "BTC") {​​​ (btcCoin) in
 observer.onNext(btcCoin)
 observer.onCompleted()
 }
 return Disposables.create()
 }
 }
 
 // 검색어에 따른 목록 재구성
 func queryFilterCoinList(coinList:[CoinData], query:String?) -> [CoinData] {
 var resultCoinList:[CoinData] = [CoinData].init()
 if let text = query {
 resultCoinList = coinList.filter({
 return $0.currency.uppercased().hasPrefix(text.uppercased())
 }​​​)
 }
 return resultCoinList
 }
 */
