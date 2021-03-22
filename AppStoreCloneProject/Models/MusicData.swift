//
//  MusicData.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/22.
//

import Foundation

// MARK: - MusicData

struct MusicDataResponse: Codable {
    var resultCount: Int
    var results: [MusicData]?
}

struct MusicData: Codable {
    let wrapperType, kind: String
    let artistId, collectionId, trackId: Int
    let artistName, collectionName, trackName, collectionCensoredName: String
    let trackCensoredName: String
    let artistViewUrl, collectionViewUrl, trackViewUrl: String
    let previewUrl: String?
    let artworkUrl60, artworkUrl100: String?
    let collectionPrice, trackPrice: Double
    let collectionExplicitness, trackExplicitness: String
    let discCount, discNumber, trackCount, trackNumber: Int
    let trackTimeMillis: Int?
    let country, currency, primaryGenreName: String
    
    enum CodingKeys: String, CodingKey {
        case wrapperType, kind
        case artistId = "artistId"
        case collectionId = "collectionId"
        case trackId = "trackId"
        case artistName, collectionName, trackName, collectionCensoredName, trackCensoredName
        case artistViewUrl = "artistViewUrl"
        case collectionViewUrl = "collectionViewUrl"
        case trackViewUrl = "trackViewUrl"
        case previewUrl = "previewUrl"
        case artworkUrl60, artworkUrl100, collectionPrice, trackPrice, collectionExplicitness, trackExplicitness, discCount, discNumber, trackCount, trackNumber, trackTimeMillis, country, currency, primaryGenreName
    }
}

// MARK: - Helper functions for creating encoders and decoders

func newJSONDecoder() -> JSONDecoder {
    let decoder = JSONDecoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        decoder.dateDecodingStrategy = .iso8601
    }
    return decoder
}

func newJSONEncoder() -> JSONEncoder {
    let encoder = JSONEncoder()
    if #available(iOS 10.0, OSX 10.12, tvOS 10.0, watchOS 3.0, *) {
        encoder.dateEncodingStrategy = .iso8601
    }
    return encoder
}

// MARK: - URLSession response handlers

extension URLSession {
    fileprivate func codableTask<T: Codable>(with url: URL, completionHandler: @escaping (T?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completionHandler(nil, response, error)
                return
            }
            completionHandler(try? newJSONDecoder().decode(T.self, from: data), response, nil)
        }
    }
    
    func musicDataTask(with url: URL, completionHandler: @escaping (MusicData?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}


/*
 //MARK: [도전과제] 코더블 사용하기
 
 // This file was generated from JSON Schema using quicktype, do not modify it directly.
 // To parse the JSON, add this file to your project and do:
 //
 //   let musicData = try? newJSONDecoder().decode(MusicData.self, from: jsonData)
 
 //
 // To read values from URLs:
 //
 //   let task = URLSession.shared.musicDataTask(with: url) { musicData, response, error in
 //     if let musicData = musicData {
 //       ...
 //     }
 //   }
 //   task.resume()
 
 
//MARK: 이거는 이제 이렇게 Json Parsing 하지 말기
//    init(dictionary: [String: Any]) {
//        self.wrapperType = dictionary["wrapperType"] as! String
//        self.kind = dictionary["kind"] as! String
//        self.artistId = dictionary["artistId"] as! Int
//        self.collectionId = dictionary["collectionId"] as! Int
//        self.trackId = dictionary["trackId"] as! Int
//        self.artistName = dictionary["artistName"] as! String
//        self.collectionName = dictionary["collectionName"] as! String
//        self.trackName = dictionary["trackName"] as! String
//        self.collectionCensoredName = dictionary["collectionCensoredName"] as! String
//        self.trackCensoredName = dictionary["trackCensoredName"] as! String
//        self.artistViewUrl = dictionary["artistViewUrl"] as! String
//        self.collectionViewUrl = dictionary["collectionViewUrl"] as! String
//        self.trackViewUrl = dictionary["trackViewUrl"] as! String
//        self.previewUrl = dictionary["previewUrl"] as? String
//        self.artworkUrl60 = dictionary["artworkUrl60"] as? String
//        self.artworkUrl100 = dictionary["artworkUrl100"] as? String
//        self.collectionPrice = dictionary["collectionPrice"] as! Double
//        self.trackPrice = dictionary["trackPrice"] as! Double
//        self.collectionExplicitness = dictionary["collectionExplicitness"] as! String
//        self.trackExplicitness = dictionary["trackExplicitness"] as! String
//        self.discCount = dictionary["discCount"] as! Int
//        self.discNumber = dictionary["discNumber"] as! Int
//        self.trackCount = dictionary["trackCount"] as! Int
//        self.trackNumber = dictionary["trackNumber"] as! Int
//        self.trackTimeMillis = dictionary["trackTimeMillis"] as? Int
//        self.country = dictionary["country"] as! String
//        self.currency = dictionary["currency"] as! String
//        self.primaryGenreName = dictionary["primaryGenreName"] as! String
//    }
 */
 
