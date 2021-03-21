//
//  ImageCacheManager.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/21.
//

import Foundation
import UIKit

class ImageCacheManager {
    
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
    
}

/*
 //MARK: 사용방법
 //이미지가 있는 View에서 아래처럼 사용
 
 func setImageUrl(_ url: String) {
     
     let cacheKey = NSString(string: url) // 캐시에 사용될 Key 값
     
     if let cachedImage = ImageCacheManager.shared.object(forKey: cacheKey) { // 해당 Key 에 캐시이미지가 저장되어 있으면 이미지를 사용
         self.image = cachedImage
         return
     }
     
     DispatchQueue.global(qos: .background).async {
         if let imageUrl = URL(string: url) {
             URLSession.shared.dataTask(with: imageUrl) { (data, res, err) in
                 if let _ = err {
                     DispatchQueue.main.async {
                         self.image = UIImage()
                     }
                     return
                 }
                 DispatchQueue.main.async {
                     if let data = data, let image = UIImage(data: data) {
                         ImageCacheManager.shared.setObject(image, forKey: cacheKey) // 다운로드된 이미지를 캐시에 저장
                         self.image = image
                     }
                 }
             }.resume()
         }
     }
 }
 
 */
