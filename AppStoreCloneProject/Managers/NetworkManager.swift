//
//  NetworkManager.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/21.
//

import Foundation

/*enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
}

enum APIError: Error {
    case notAuthorized
    case notValidRequest
    case notHasData
    case notDecodingEnabled
}

protocol APIType {
    var baseURLString: String { get }
    var path: String { get }
    var queryParameters: [String: Any]? { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
}

extension APIType {
    var request: URLRequest? {
        var urlComponet = URLComponents(string: baseURLString + path)
        if let parameters = queryParameters {
            var queryItems: [URLQueryItem] = []
            parameters.forEach { (key, value) in
                let item = URLQueryItem(name: key, value: value as? String)
                queryItems.append(item)
            }
            urlComponet?.queryItems = queryItems
        }
        
        if let url = urlComponet?.url {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.allHTTPHeaderFields = headers
            return request
        } else {
            return nil
        }
    }
}

struct APIClient {
    static let developerToken = "your developer token!!"
    static let countryCode = "us"
}

struct APIDefault {
    static let headers = ["Authorization": "Bearer \(APIClient.developerToken)"]
    static let baseURLString = "https://itunes.apple.com/search?"
}

enum IAPIType: APIType {
    case fetchOne(id: String)
    case fetchMany(ids: [String])
        
        var baseURLString: String {
            return APIDefault.baseURLString
        }
        
        var path: String {
            switch self {
            case .fetchOne(let id):
                return "/v1/catalog/\(APIClient.countryCode)/artists/\(id)"
            case .fetchMany:
                return "/v1/catalog/\(APIClient.countryCode)/artists"
            }
        }
        
        var queryParameters: [String: Any]? {
            switch self {
            case .fetchMany(let ids):
                return ["ids": ids]
            default:
                return nil
            }
        }

    var method: HTTPMethod {
            return .get
        }
        
        var headers: [String: String]? {
            return APIDefault.headers
        }
    }

    
*/
