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
            var data: SearchResultModel?
        }
      }
    
}
