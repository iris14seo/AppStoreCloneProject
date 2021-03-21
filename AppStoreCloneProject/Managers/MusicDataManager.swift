//
//  ItunesSearchAPI.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/21.
//

import Foundation

class MusicDataManager {
    
    static let shared = MusicDataManager()
    
    private let defaultUrl = "https://itunes.apple.com/search?term="
    
    private init() {}
    
    func getMusicList(keyWord: String?, completion: @escaping (Result<[MusicData]?, Error>) -> Void) {
        guard let keyWord = keyWord else {
            //잘못된 검색어 입력
            return
        }
        guard let requestURL = URL(string: defaultUrl + keyWord + "&limit=3") else {return}
        
        //URLSession 싱글톤 객체
        //let sessionConfiguration = URLSessionConfiguration.default
        let session = URLSession.shared//URLSession(configuration: sessionConfiguration)

        //네트워킹 시작
        session.dataTask(with: requestURL) { data, response, error in
            guard error == nil else {
                print(error?.localizedDescription)
                completion(.failure(error!))
                return
            }
            
            if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                do {
                    //Json타입의 데이터를 디코딩
                    let musicResponse = try JSONDecoder().decode(MusicDataResponse.self, from: data)
                    
                    if let results = musicResponse.results {
                        var musicList = [MusicData]()
                        for data in results {
                            let musicData = MusicData.init(wrapperType: "", kind: "", artistID: 0, collectionID: 0, trackID: 0, artistName: "", collectionName: "", trackName: "", collectionCensoredName: "", trackCensoredName: "", artistViewURL: "", collectionViewURL: "", trackViewURL: "", previewURL: "", artworkUrl60: "", artworkUrl100: "", collectionPrice: 0.0, trackPrice: 0.0, collectionExplicitness: "", trackExplicitness: "", discCount: 0, discNumber: 0, trackCount: 0, trackNumber: 0, trackTimeMillis: 0, country: "", currency: "", primaryGenreName: "")//self.convertToCoinDataFromDic(dic: data)
                            print(data)
                            musicList.append(musicData)
                        }
                        completion(.success(musicList))
                    }
                } catch(let err) {
                    print("Decoding Error")
                    print(err.localizedDescription)
                    completion(.failure(err))
                }
            }
        }.resume()
    }
    
    /*func convertToMusicDataFromDic(dic:[String:JSON]) -> CoinData {
        let currency = dic["currency"]?.string ?? ""
        let koreanName = DataManager.shared.getCurrencyKoreanName(currency: currency)
        let volumn = Double.init(dic["volume"]?.string ?? "0") ?? 0
        let high = Double.init(dic["high"]?.string ?? "0") ?? 0
        let low = Double.init(dic["low"]?.string ?? "0") ?? 0
        let first = Double.init(dic["first"]?.string ?? "0") ?? 0
        let last = Double.init(dic["last"]?.string ?? "0") ?? 0
        let yesterdayVolumn = Double.init(dic["yesterday_volume"]?.string ?? "0") ?? 0
        let yesterdayHigh = Double.init(dic["yesterday_high"]?.string ?? "0") ?? 0
        let yesterdayLow = Double.init(dic["yesterday_low"]?.string ?? "0") ?? 0
        let yesterdayFirst = Double.init(dic["yesterday_first"]?.string ?? "0") ?? 0
        let yesterdayLast = Double.init(dic["yesterday_last"]?.string ?? "0") ?? 0
        let changePercent = ((last - yesterdayLast) / yesterdayLast) * 100
        
        let coinData = CoinData.init(currency: currency,
                      koreanName: koreanName,
                      volumn: volumn,
                      high: high,
                      low: low,
                      first: first,
                      last: last,
                      yesterdayVolumn: yesterdayVolumn,
                      yesterdayHigh: yesterdayHigh ,
                      yesterdayLow: yesterdayLow,
                      yesterdayFirst: yesterdayFirst,
                      yesterdayLast: yesterdayLast,
                      changePercent: changePercent)
        
        return coinData
    }*/
}
