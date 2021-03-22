//
//  UIImage+Extension.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/20.
//

import UIKit

extension UIImage {
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        
        color.setFill()
        UIRectFill(rect)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        
        self.init(cgImage: cgImage)
    }
}

extension UIImageView {
    
    /**
     이미지뷰에 URL로 부터 Cache 이미지 설정하는 Extention 함수
     - url: URL
     */
    func setCacheImageURL(_ url: URL?) {
        self.setCacheImageURL(url, nil)
    }
    
    /**
     이미지뷰에 URL로 부터 Cache 이미지 설정하는 Extention 함수
     - url: URL
     - success: 성공 block
     */
    func setCacheImageURL(_ url: URL?, _ success: ((_ image: UIImage) -> Void)? = nil) {
        let urlString = url?.absoluteString ?? ""
        if urlString.isEmpty {
            self.image = nil
            return
        }
        
        self.image = nil
        
        ImageCacheManager.shared.requestImageURL(url, { [weak self] (image) in
            self?.image = image
            if let success = success {
                success(image)
            }
        }) { (error) in
            print(error)
        }
    }
}
