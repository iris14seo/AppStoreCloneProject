//
//  AppStoreSearchModels.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit

enum AppStoreSearch {
    
    //Use Case1 - 최근 검색어 조회하기(전체 목록 vs 입력된 검색어 기반 필터 목록)
    enum RecentWord {
        struct Request {
            var dataType: DataType
            var keyWord: String?
            
            enum DataType {
                case all
                case filtered
            }
        }
        
        struct Response {
            var recentWordList: [String]?
        }
        
        struct ViewModel{
            var recentWordList: [String]?
        }
    }
    
    //Use Case2 - 입력된 단어로 API 검색하기 //키보드에서 enter 누른 경우 OR 테이블 뷰에서 didSelectRow한 경우
    enum SearchWord {
        struct Request {
            var keyWord: String
        }
        
        struct Response {
            var musicDataList: [MusicData]?
        }
        
        struct ViewModel{
            var musicDataList: [MusicData]?
        }
    }
    
    enum ViewMode {
        case recentWord
        case searchWord
    }
}


/*//MARK: Use Case3 - delete 버튼 누름
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
}*/
