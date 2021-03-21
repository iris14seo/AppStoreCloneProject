//
//  AppStoreSearchModels.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit

enum AppStoreSearch {
    
    //MARK: Use Case1 - 저장된 최근 검색어 보여주기(전체 목록 vs 입력된 검색어 기반 필터 목록)
    enum LoadStoredRecentWord {
        struct Request {
            var dataSource: WordDataSource
        }
        
        struct Response {
        }
        
        struct ViewModel{
        }
        
        enum WordDataSource { //MARK: 네이밍 뭐라고 하지??
            case wholeWords
            case filteredWords
        }
    }
    
    //MARK: Use Case2 - 입력된 단어로 검색하기 //키보드에서 enter 누른 경우 OR 테이블 뷰에서 didSelectRow한 경우
    enum SearchWord {
        struct Request {
        }
        
        struct Response {
        }
        
        struct ViewModel{
        }
    }
    
    //MARK: Use Case3 - delete 버튼 누름
    enum DeleteWord {
        struct Request {
        }
        
        struct Response {
        }
        
        struct ViewModel{
        }
    }
    
    //MARK: Use Case4 - 검색 모드 변경
    enum ChangeSearchMode {
        struct Request {
            var searchMode: SearchMode
        }
        
        struct Response {
        }
        
        struct ViewModel{
        }
        
        enum SearchMode {
            case active //searchBar 탭해서 검색모드 활성화
            case deactive //cancel 버튼 눌러서 검색모드 비활성화
        }
    }
}
