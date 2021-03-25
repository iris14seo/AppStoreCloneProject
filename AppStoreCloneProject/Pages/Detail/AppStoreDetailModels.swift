//
//  AppStoreDetailModels.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit

enum AppStoreDetail {
    
    // MARK: Use cases
    
    enum FetchData {
        struct Request {
        }
        
        struct Response {
            var data: SearchResultModel?
        }
        
        struct ViewModel{
            var data: SoftWareDetailDataModel?
        }
    }
    
    /**
     
     # 타입
     - 타이틀 //trackName
     - 설명 //genres
     - 아이콘 //artworkUrl100
     - 별점 //averageUserRating 추가정보
     - 다운로드 횟수 //userRatingCount 추가정보
     - 권장 나이 //contentAdvisoryRating 추가정보
     - 언어 //languageCodesISO2A 추가정보
     - 최소지원 버전//minimumOsVersion 추가정보
     - 스크린샷 콜렉션뷰 이미지 URLs //screenshotUrls
     - 기기정보 //supportedDevices
     - 상세정보 //description
     - 개발자 //sellerName
     */
    struct SoftWareDetailDataModel: Equatable {
        var title: String?
        var genres: String?
        var iconImageURL: String?
        var downloadURL: String?
        var ratingScore: Double?
        var downloadCount: String?
        var recommenedAge: String?
        var baseLanguage: String?
        var minimumOsVersion: String?
        var screenShotURLList: [String]?
        var supportedDevices: [SupportedDevice]?
        var longDescription: String?
        var developerID: String?
    }
    
    enum SupportedDevice: String {
        case iPhone
        case iPad
    }
}

