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
     - CoreData에 저장된 검색어목록 페이징 처리하여 노출
     
     # 필터된 목록 노출
     - 키워드 입력 후, 해당 단어 기반으로 필터된 검색어목록 노출
     */
    enum HistoryWord {
        struct Request {
            var target: TargetTableView
            var keyWord: String?
        }
        
        struct Response {
            var target: TargetTableView
            var historyWordList: [String]?
        }
        
        struct ViewModel{
            var target: TargetTableView
            var historyWordList: [String]?
        }
        
        enum TargetTableView {
            case main
            case search
        }
    }
    
    /**Use Case2 - 입력된 키워드 기반 검색
     
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
            var softWareDataList: [SoftWareCellData]?
        }
    }
    
    /**검색 TableView에서 발생 가능한 타입정리
     
     # 타입
     - history: 로컬 최근검색한 경우
     - search: API 검색한 경우
     - notFound: API 검색결과 없는 경우
     */
    enum ResultType {
        case history
        case search
        case notFound
    }
}
