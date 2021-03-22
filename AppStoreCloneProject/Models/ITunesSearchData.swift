//
//  ITunesSearchData.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/22.
//

import Foundation

// MARK: - ITunesSearchData

struct ITunesSearchDataResponse: Codable {
    var resultCount: Int?
    var results: [ITunesSearchData]?
}

struct ITunesSearchData: Codable {
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
    
    enum CodingKeys: String, CodingKey {
        case wrapperType, kind
        case artistID = "artistId"
        case collectionID = "collectionId"
        case trackID = "trackId"
        case artistName, collectionName, trackName, collectionCensoredName, trackCensoredName
        case artistViewURL = "artistViewUrl"
        case collectionViewURL = "collectionViewUrl"
        case trackViewURL = "trackViewUrl"
        case previewURL = "previewUrl"
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
    
    func iTunesSearchDataTask(with url: URL, completionHandler: @escaping (ITunesSearchData?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return self.codableTask(with: url, completionHandler: completionHandler)
    }
}
