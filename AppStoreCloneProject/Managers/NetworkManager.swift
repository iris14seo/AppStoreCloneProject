//
//  NetworkManager.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/21.
//MARK: escape 처리, safe 처리

import Foundation

enum APIResult<U> {
    case success(result: U)
    case failure(error: APIError)
}

enum APIError: Error {
    case urlNotSupportError
    case responseError
    case serverError
    case decodeError
    case noResultError
    case unknownError
}

protocol APIProtocol {
    var baseURLString: String { get }
    var path: APIPath { get }
    var queryParameters: [String: Any]? { get }
    var method: HTTPMethod { get }
}

struct APIBaseURL {
    static let url = "https://itunes.apple.com"
}

enum APIPath: String {
    case searchPath = "/search"
    case lookUpPath = "/lookup"
}

enum HTTPMethod: String {
    case get = "GET" //이번 프로젝트에선 얘만 사용
    case post = "POST"
    //case put = "PUT" //잘 안씀
    //case delete = "DELETE" //잘 안씀
}

typealias CompletionHandler = (APIResult<[SoftwareDataModel]?>) -> Void

class NetworkManager {
    
    static let shared: NetworkManager = NetworkManager()
    
    private var session: URLSession?
    
    private var sessionConfiguration: URLSessionConfiguration = .default
    private let requestCachePolicy: NSURLRequest.CachePolicy = .useProtocolCachePolicy
    private let timeoutInterval: TimeInterval = 60.0
    
    private init() {
        self.sessionConfiguration.requestCachePolicy = requestCachePolicy
        self.session = URLSession(configuration: self.sessionConfiguration)
    }
    
    /**JSON 요청 함수
     
     #매개변수
     - baseURLString: String
     - path: APIPath
     - queryParameters: 파라미터
     - method: HTTPMethod
     - completionHandler: (APIResult<[T]?>) -> Void
     */
    func requestJSON(_ baseURLString: String = APIBaseURL.url,
                 path: APIPath,
                 queryParameters: [String: Any]?,
                 method: HTTPMethod,
                 completionHandler: @escaping CompletionHandler) {
        
        //URL 가공
        guard let url = URL(string: baseURLString + path.rawValue) else {
            completionHandler(.failure(error: .urlNotSupportError))
            return
        }
        
        var urlRequest = URLRequest(url: url, cachePolicy: requestCachePolicy, timeoutInterval: timeoutInterval)
        urlRequest.httpMethod = method.rawValue
        
        switch method {
        case .get:
            if var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false), let parameters = queryParameters, !parameters.isEmpty {
                
                let percentEncodedQuery = (urlComponents.percentEncodedQuery.map { $0 + "&" } ?? "") + query(parameters)
                urlComponents.percentEncodedQuery = percentEncodedQuery
                urlRequest.url = urlComponents.url
            }
            break
            
        case .post:
            do {
                let data = try JSONSerialization.data(withJSONObject: queryParameters as Any, options: [])
                urlRequest.httpBody = data
            } catch let error as NSError {
                fatalError("Json 생성중 에러발생: \(error)")
            }
            break
        }
        
        //print(urlRequest)
        
        //네트워킹 시작
        let task = session?.dataTask(with: urlRequest) { (data, response, error) in
            
            guard error == nil else {
                completionHandler(.failure(error: .responseError))
                return
            }
            
            if let resultData = data,
               let response = response as? HTTPURLResponse {
                //dump(resultData)
                switch response.statusCode {
                case 200 ..< 300:
                    do {
                        //JSON타입의 데이터를 디코딩
                        let decoder = JSONDecoder()
                        let softWareResponse = try decoder.decode(SoftwareDataResponseModel.self, from: resultData)
                        //dump(softWareResponse)
                        
                        completionHandler(.success(result: softWareResponse.results))
                    } catch let jsonError as NSError {
                        print("JSON decode failed: \(jsonError.localizedDescription)")
                        completionHandler(.failure(error: .decodeError))
                    }
                case 400 ..< 500:
                    completionHandler(.failure(error: .serverError))
                default:
                    completionHandler(.failure(error: .unknownError))
                }
            }
        }
        
        task?.resume()
    }
    
    /**데이타 타입을 체크하여 escape된 형태로 변환해주는 배열 함수
     
     #매개변수
     - fromKey: 키값
     - value: value값*/
     /// - Returns: 키/value 배열
    public func queryComponents(fromKey key: String, value: Any) -> [(String, String)] {
        var components: [(String, String)] = []
        
        if let dictionary = value as? [String: Any] {
            for (nestedKey, value) in dictionary {
                components += queryComponents(fromKey: "\(key)[\(nestedKey)]", value: value)
            }
            
        } else if let array = value as? [Any] {
            for value in array {
                components += queryComponents(fromKey: "\(key)[]", value: value)
            }
            
        } else if let value = value as? NSNumber {
            if value.isBool {
                components.append((escape(key), escape(value.boolValue ? "1" : "0")))
            } else {
                components.append((escape(key), escape("\(value)")))
            }
            
        } else if let bool = value as? Bool {
            components.append((escape(key), escape(bool ? "1" : "0")))
            
        } else {
            components.append((escape(key), escape("\(value)")))
            
        }
        
        return components
    }
    
    /**문자를 'URL escape' 해주는 함수
     
     #매개변수
     - string: 문자*/
    /// - Returns: escape 처리 된 문자
    public func escape(_ string: String) -> String {
        let generalDelimitersToEncode = ":#[]@"
        let subDelimitersToEncode = "!$&'()*+,;="
        
        var allowedCharacterSet = CharacterSet.urlQueryAllowed
        allowedCharacterSet.remove(charactersIn: "\(generalDelimitersToEncode)\(subDelimitersToEncode)")
        
        var escaped = ""
        
        if #available(iOS 8.3, *) {
            escaped = string.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? string
        } else {
            let batchSize = 50
            var index = string.startIndex
            
            while index != string.endIndex {
                let startIndex = index
                let endIndex = string.index(index, offsetBy: batchSize, limitedBy: string.endIndex) ?? string.endIndex
                let range = startIndex..<endIndex
                
                let substring = string[range]
                
                escaped += substring.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) ?? String(substring)
                
                index = endIndex
            }
        }
        
        return escaped
    }
    
    /**파라미터 인코딩 변환해서 & 값으로 연결 해주는 함수
     
     #매개변수
     - parameters: 파라미터*/
    /// - Returns: 문자열
    private func query(_ parameters: [String: Any]) -> String {
        var components: [(String, String)] = []
        
        for key in parameters.keys.sorted(by: <) {
            let value = parameters[key]!
            components += queryComponents(fromKey: key, value: value)
        }
        return components.map { "\($0)=\($1)" }.joined(separator: "&")
    }
    
}

extension NSNumber {
    /**Bool인지 체크*/
    /// - Returns: Bool 값이 참인지 아닌지 여부 값
    var isBool: Bool { return CFBooleanGetTypeID() == CFGetTypeID(self) }
}
