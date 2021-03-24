//
//  AppStoreSearchModels.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit

enum AppStoreSearch {
    
    /**Use Case1 - 로컬 최근검색어 기반 검색
     
     # 전체 목록 노출
     - UserDefault에 저장된 검색어목록 페이징 처리하여 노출
     */
    enum AllHistoryWord {
        struct Request {
        }
        
        struct Response {
            var historyWordList: [String]?
        }
        
        struct ViewModel{
            var historyWordList: [String]?
        }
    }
    
    /**Use Case2 - 로컬 최근검색어 기반 검색
     
     # 필터된 목록 노출
     - 키워드 입력 후, 해당 단어 기반으로 필터된 검색어목록 노출
     */
    enum FilteredHistoryWord {
        struct Request {
            var keyWord: String?
        }
        
        struct Response {
            var historyWordList: [String]?
        }
        
        struct ViewModel{
            var historyWordList: [String]?
        }
    }
    
    /**Use Case3 - 입력된 키워드 기반 검색
     
     # 로컬 최근검색 시나리오
     - SearchBar에 키워드 입력한 경우
     
     # API 검색 시나리오
     - 키워드 입력 후, KeyBoard에서 enter 누른 경우
     - 검색 TableView에서 didSelectRow한 경우
     */
    enum SearchWord {
        struct Request {
            var keyWord: String
        }
        
        struct Response {
            var softWareDataList: [SearchResultModel]?
        }
        
        struct ViewModel{
            var softWareDataList: [SoftWareCellDataModel]?
        }
    }
    
    /**검색 TableView에서 발생 가능한 타입정리
     
     # 타입
     - localHistory: 로컬 최근검색한 경우
     - apiSearch: API 검색한 경우
     - noResult: API 검색결과 없는 경우
     */
    enum ResultType {
        case localHistory
        case apiSearch
        case noResult
    }
}
