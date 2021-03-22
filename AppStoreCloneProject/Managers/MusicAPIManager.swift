//
//  ItunesSearchAPI.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/21.
//

import Foundation
import RxSwift

public let defaultDataSize: Int = 10

public enum APIError: LocalizedError {
    case urlNotSupportError
    case responseError //MARK: [고민] 네이밍 고민중
    case serverError
    case decodeError
    case noResultError
    case unknownError
    
    public var errorDescription: String? {
        switch self {
        case .urlNotSupportError:
            return "URL not supported"
        case .responseError:
            return "Response error occured"
        case .serverError:
            return "Server error occured"
        case .decodeError:
            return "Decode error occured"
        case .noResultError:
            return "No results error"
        case .unknownError:
            return "Unknown error occured"
        }
    }
}

class MusicAPIManager {
    
    static let shared: MusicAPIManager = MusicAPIManager()
    
    private lazy var defaultSession = URLSession(configuration: .default)
    private let defaultSearchUrl: String = "https://itunes.apple.com/search?term="
    private let dataResponseLimit: String = "&limit="
    
    private init() {}
    
    //GET 음악 데이터 검색 결과
    func getMusicDataList(keyWord: String, limit: Int = defaultDataSize, completionHandler:  @escaping (Result<[MusicData]?, APIError>) -> Void) {
        
        //URL
        let dataResponseLimitString = limit > 0 ? (dataResponseLimit + String(limit)) : (dataResponseLimit + String(defaultDataSize))
        
        guard let requestURL = URL(string: defaultSearchUrl + keyWord.lowercased() + dataResponseLimitString) else {
            completionHandler(.failure(.urlNotSupportError))
            return
        }

        //네트워킹 시작
        defaultSession.dataTask(with: requestURL) { data, response, error in
            guard error == nil else {
                completionHandler(.failure(.responseError))
                //print("Response Error", error?.localizedDescription)
                return
            }
            
            if let jsonData = data, let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200 ..< 300:
                    do {
                        //Json타입의 데이터를 디코딩
                        let decoder = JSONDecoder()
                        let musicResponse = try decoder.decode(MusicDataResponse.self, from: jsonData)
                        dump(musicResponse)
                        
                        completionHandler(.success(musicResponse.results))
                    } catch { // catch (let error) {
                        completionHandler(.failure(.decodeError))
                        //print("Decoding Error", error.localizedDescription)
                    }
                case 400 ..< 500:
                    completionHandler(.failure(.serverError))
                default:
                    completionHandler(.failure(.unknownError))
                }
                
            }
        }.resume()
    }
}


//참고
//- RX 에러 한곳에서 다루기: http://minsone.github.io/programming/rxswift-hanlding-error

/*
//MARK: [도전] 이런식으로 사용하지는 못하나?
public enum APIResult<U> {
    case success(result: U)
    case failure(error: APIError)
}
typealias SearchMusicCompletionHandler = (APIResult<[MusicData]?>) -> Void
 */
