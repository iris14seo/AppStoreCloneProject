//
//  AppStoreSearchModels.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit

enum AppStoreSearch {
    
    //Use Case1 - 최근 검색어 조회하기(전체 목록 vs 입력된 검색어 기반 필터 목록)
    enum HistoryWord {
        struct Request {
            var dataType: DataType
            var keyWord: String?
            
            enum DataType {
                case all
                case filtered
            }
        }
        
        struct Response {
            var historyWordList: [String]?
        }
        
        struct ViewModel{
            var historyWordList: [String]?
        }
    }
    
    //Use Case2 - 입력된 단어로 API 검색하기 //키보드에서 enter 누른 경우 OR 테이블 뷰에서 didSelectRow한 경우
    enum SearchWord {
        struct Request {
            var keyWord: String
        }
        
        struct Response {
            var iTunesSearchDataList: [ITunesSearchData]?
        }
        
        struct ViewModel{
            var iTunesSearchDataList: [ITunesSearchData]?
        }
        
        struct FormmatedSearchData: Equatable {
            var wrapperType, kind: String?
            var artistID, collectionID, trackID: Int?
            var artistName, collectionName, trackName, collectionCensoredName: String?
            var trackCensoredName: String?
            var artistViewURL, collectionViewURL, trackViewURL: String?
            var previewURL: String?
            var artworkUrl60, artworkUrl100: String?
            let collectionPrice, trackPrice: Double?
            var collectionExplicitness, trackExplicitness: String?
            var discCount, discNumber, trackCount, trackNumber: Int?
            var trackTimeMillis: Int?
            var country, currency, primaryGenreName: String?
        }
    }
}

public enum SearchResultType {
    case history
    case search
    case notFound
}
