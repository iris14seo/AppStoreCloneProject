//
//  ImageCacheManager.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/21.
//

import Foundation
import UIKit

class ImageCacheManager {
    
    static let shared = ImageCacheManager()
        
    private var operationQueue: OperationQueue?
    private var imageSession: URLSession?
    private var sessionConfiguration: URLSessionConfiguration?
    private let requestCachePolicy: NSURLRequest.CachePolicy = .useProtocolCachePolicy
    private let timeoutInterval: TimeInterval = 60.0
    
    private let urlCache = URLCache(memoryCapacity: 20 * 1024 * 1024, diskCapacity: 100 * 1024 * 1024, diskPath: "ImageDownloadCache")
    
    typealias SuccessHandler = (_ image: UIImage) -> Void
    typealias FailureHandler = (_ error: APIError) -> Void
        
    private init() {
        operationQueue = OperationQueue()
        operationQueue?.maxConcurrentOperationCount = 3
        operationQueue?.name = "ImageDownload Operation"
        
        sessionConfiguration = URLSessionConfiguration.default
        sessionConfiguration?.requestCachePolicy = requestCachePolicy
        sessionConfiguration?.urlCache = urlCache
        
        imageSession = URLSession(configuration: sessionConfiguration!, delegate: nil, delegateQueue: operationQueue!)
    }
    
    /**
     통신 캐쉬 이미지 요청 함수
     
     # 매개변수
     - url: URL
     - success: 성공 block
     - failure: 실패 block
     */
    func requestImageURL(_ url: URL?, _ success: @escaping SuccessHandler, _ failure: @escaping FailureHandler) {
        guard let url = url else {
            return
        }
        
        let urlRequest = URLRequest(url: url, cachePolicy: requestCachePolicy, timeoutInterval: timeoutInterval)
        
        if let cacheResponse = urlCache.cachedResponse(for: urlRequest) {
            if let cachedImage = UIImage.init(data: cacheResponse.data) {
                DispatchQueue.main.async {
                    success(cachedImage)
                }
                return
            }
        }
        
        let task = imageSession?.dataTask(with: url, completionHandler: { (data, response, error) in
            guard error == nil else {
                DispatchQueue.main.async {
                    failure(.responseError)
                }
                return
            }
            
            if let response = response as? HTTPURLResponse {
                switch response.statusCode {
                case 200 ..< 300:
                    if let data = data {
                        let cacheResponse = CachedURLResponse(response: response, data: data)
                        self.urlCache.storeCachedResponse(cacheResponse, for: urlRequest)
                        
                        DispatchQueue.main.async {
                            if let image = UIImage.init(data: data) {
                                success(image)
                            }
                        }
                    }
                    
                case 400 ..< 500:
                    DispatchQueue.main.async {
                        failure(.serverError)
                    }
                    
                default:
                    DispatchQueue.main.async {
                        failure(.unknownError)
                    }
                }
            }
            
            return
            
        })
        
        task?.resume()
    }
    
    func getCacheImagebyURL(_ url: URL?, _ success: ((_ image: UIImage) -> Void)? = nil) {
        let urlString = url?.absoluteString ?? ""
        if urlString.isEmpty {
            return
        }
        
        ImageCacheManager.shared.requestImageURL(url, { (image) in
            if let success = success {
                success(image)
            }
        }) { (error) in
            print(error)
        }
    }
}
