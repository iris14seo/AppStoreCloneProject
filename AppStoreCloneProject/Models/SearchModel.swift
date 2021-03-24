//
//  SearchModel.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/23.
//

import UIKit

/**
 Search API Search API 조회시 받아오는, response 구조체
 */
struct SearchModel: Codable {
    let resultCount: Int?
    let results: [SearchResultModel]?
    
    private enum CodingKeys: String, CodingKey {
        case resultCount = "resultCount"
        case results = "results"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let resultCount = try container.decode(Int.self, forKey: .resultCount)
        let results = try container.decode([SearchResultModel].self, forKey: .results)
        
        self.resultCount = resultCount
        self.results = results
    }
}

struct SearchResultModel: Codable {
    
    let isGameCenterEnabled: Bool?
    let screenshotUrls: [String]?
    let ipadScreenshotUrls: [String]?
    let appletvScreenshotUrls: [String]?
    let artworkUrl60: String?
    let artworkUrl512: String?
    let artworkUrl100: String?
    let artistViewUrl: String?
    let advisories: [String]?
    let supportedDevices: [String]?
    let kind: String?
    let features: [String]?
    let averageUserRatingForCurrentVersion: Double?
    let trackCensoredName: String?
    let languageCodesISO2A: [String]?
    let fileSizeBytes: Int64?
    let sellerUrl: String?
    let contentAdvisoryRating: String?
    let userRatingCountForCurrentVersion: Int?
    let trackViewUrl: String?
    let trackContentRating: String?
    let sellerName: String?
    let primaryGenreId: String?
    let currentVersionReleaseDate: Date?
    let isVppDeviceBasedLicensingEnabled: Bool?
    let genreIds: [String]?
    let releaseNotes: String?
    let minimumOsVersion: String?
    let primaryGenreName: String?
    let releaseDate: Date?
    let currency: String?
    let wrapperType: String?
    let version: String?
    let description: String?
    let artistId: String?
    let artistName: String?
    let genres: [String]?
    let price: Double?
    let bundleId: String?
    let trackId: String?
    let trackName: String?
    let formattedPrice: String?
    let averageUserRating: Double?
    let userRatingCount: Int64?
    
    private enum CodingKeys: String, CodingKey {
        case isGameCenterEnabled = "isGameCenterEnabled"
        case screenshotUrls = "screenshotUrls"
        case ipadScreenshotUrls = "ipadScreenshotUrls"
        case appletvScreenshotUrls = "appletvScreenshotUrls"
        case artworkUrl60 = "artworkUrl60"
        case artworkUrl512 = "artworkUrl512"
        case artworkUrl100 = "artworkUrl100"
        case artistViewUrl = "artistViewUrl"
        case advisories = "advisories"
        case supportedDevices = "supportedDevices"
        case kind = "kind"
        case features = "features"
        case averageUserRatingForCurrentVersion = "averageUserRatingForCurrentVersion"
        case trackCensoredName = "trackCensoredName"
        case languageCodesISO2A = "languageCodesISO2A"
        case fileSizeBytes = "fileSizeBytes"
        case sellerUrl = "sellerUrl"
        case contentAdvisoryRating = "contentAdvisoryRating"
        case userRatingCountForCurrentVersion = "userRatingCountForCurrentVersion"
        case trackViewUrl = "trackViewUrl"
        case trackContentRating = "trackContentRating"
        case sellerName = "sellerName"
        case primaryGenreId = "primaryGenreId"
        case currentVersionReleaseDate = "currentVersionReleaseDate"
        case isVppDeviceBasedLicensingEnabled = "isVppDeviceBasedLicensingEnabled"
        case genreIds = "genreIds"
        case releaseNotes = "releaseNotes"
        case minimumOsVersion = "minimumOsVersion"
        case primaryGenreName = "primaryGenreName"
        case releaseDate = "releaseDate"
        case currency = "currency"
        case wrapperType = "wrapperType"
        case version = "version"
        case description = "description"
        case artistId = "artistId"
        case artistName = "artistName"
        case genres = "genres"
        case price = "price"
        case bundleId = "bundleId"
        case trackId = "trackId"
        case trackName = "trackName"
        case formattedPrice = "formattedPrice"
        case averageUserRating = "averageUserRating"
        case userRatingCount = "userRatingCount"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let isGameCenterEnabled = try? container.decodeSafe(Bool.self, forKey: .isGameCenterEnabled)
        let screenshotUrls = try? container.decodeSafe([String].self, forKey: .screenshotUrls)
        let ipadScreenshotUrls = try? container.decodeSafe([String].self, forKey: .ipadScreenshotUrls)
        let appletvScreenshotUrls = try? container.decodeSafe([String].self, forKey: .appletvScreenshotUrls)
        let artworkUrl60 = try? container.decodeSafe(String.self, forKey: .artworkUrl60)
        let artworkUrl512 = try? container.decodeSafe(String.self, forKey: .artworkUrl512)
        let artworkUrl100 = try? container.decodeSafe(String.self, forKey: .artworkUrl100)
        let artistViewUrl = try? container.decodeSafe(String.self, forKey: .artistViewUrl)
        let advisories = try? container.decodeSafe([String].self, forKey: .advisories)
        let supportedDevices = try? container.decodeSafe([String].self, forKey: .supportedDevices)
        let kind = try? container.decodeSafe(String.self, forKey: .kind)
        let features = try? container.decodeSafe([String].self, forKey: .features)
        let averageUserRatingForCurrentVersion = try? container.decodeSafe(Double.self, forKey: .averageUserRatingForCurrentVersion)
        let trackCensoredName = try? container.decodeSafe(String.self, forKey: .trackCensoredName)
        let languageCodesISO2A = try? container.decodeSafe([String].self, forKey: .languageCodesISO2A)
        let fileSizeBytes = try? container.decodeSafe(Int64.self, forKey: .fileSizeBytes)
        let sellerUrl = try? container.decodeSafe(String.self, forKey: .sellerUrl)
        let contentAdvisoryRating = try? container.decodeSafe(String.self, forKey: .contentAdvisoryRating)
        let userRatingCountForCurrentVersion = try? container.decodeSafe(Int.self, forKey: .userRatingCountForCurrentVersion)
        let trackViewUrl = try? container.decodeSafe(String.self, forKey: .trackViewUrl)
        let trackContentRating = try? container.decodeSafe(String.self, forKey: .trackContentRating)
        let sellerName = try? container.decodeSafe(String.self, forKey: .sellerName)
        let primaryGenreId = try? container.decodeSafe(String.self, forKey: .primaryGenreId)
        let currentVersionReleaseDate = try? container.decodeSafe(String.self, forKey: .currentVersionReleaseDate)
        let isVppDeviceBasedLicensingEnabled = try? container.decodeSafe(Bool.self, forKey: .isVppDeviceBasedLicensingEnabled)
        let genreIds = try? container.decodeSafe([String].self, forKey: .genreIds)
        let releaseNotes = try? container.decodeSafe(String.self, forKey: .releaseNotes)
        let minimumOsVersion = try? container.decodeSafe(String.self, forKey: .minimumOsVersion)
        let primaryGenreName = try? container.decodeSafe(String.self, forKey: .primaryGenreName)
        let releaseDate = try? container.decodeSafe(String.self, forKey: .releaseDate)
        let currency = try? container.decodeSafe(String.self, forKey: .currency)
        let wrapperType = try? container.decodeSafe(String.self, forKey: .wrapperType)
        let version = try? container.decodeSafe(String.self, forKey: .version)
        let description = try? container.decodeSafe(String.self, forKey: .description)
        let artistId = try? container.decodeSafe(String.self, forKey: .artistId)
        let artistName = try? container.decodeSafe(String.self, forKey: .artistName)
        let genres = try? container.decodeSafe([String].self, forKey: .genres)
        let price = try? container.decodeSafe(Double.self, forKey: .price)
        let bundleId = try? container.decodeSafe(String.self, forKey: .bundleId)
        let trackId = try? container.decodeSafe(String.self, forKey: .trackId)
        let trackName = try? container.decodeSafe(String.self, forKey: .trackName)
        let formattedPrice = try? container.decodeSafe(String.self, forKey: .formattedPrice)
        let averageUserRating = try? container.decodeSafe(Double.self, forKey: .averageUserRating)
        let userRatingCount = try? container.decodeSafe(Int64.self, forKey: .userRatingCount)
        
        self.isGameCenterEnabled = isGameCenterEnabled ?? false
        self.screenshotUrls = screenshotUrls ?? []
        self.ipadScreenshotUrls = ipadScreenshotUrls ?? []
        self.appletvScreenshotUrls = appletvScreenshotUrls ?? []
        self.artworkUrl60 = artworkUrl60 ?? ""
        self.artworkUrl512 = artworkUrl512 ?? ""
        self.artworkUrl100 = artworkUrl100 ?? ""
        self.artistViewUrl = artistViewUrl ?? ""
        self.advisories = advisories ?? []
        self.supportedDevices = supportedDevices ?? []
        self.kind = kind ?? ""
        self.features = features ?? []
        self.averageUserRatingForCurrentVersion = averageUserRatingForCurrentVersion ?? 0.0
        self.trackCensoredName = trackCensoredName ?? ""
        self.languageCodesISO2A = languageCodesISO2A ?? []
        self.fileSizeBytes = fileSizeBytes ?? 0
        self.sellerUrl = sellerUrl ?? ""
        self.contentAdvisoryRating = contentAdvisoryRating ?? ""
        self.userRatingCountForCurrentVersion = userRatingCountForCurrentVersion ?? 0
        self.trackViewUrl = trackViewUrl ?? ""
        self.trackContentRating = trackContentRating ?? ""
        self.sellerName = sellerName ?? ""
        self.primaryGenreId = primaryGenreId ?? ""
        self.currentVersionReleaseDate = Date.convertAppleStringToDate(currentVersionReleaseDate ?? "")
        self.isVppDeviceBasedLicensingEnabled = isVppDeviceBasedLicensingEnabled ?? false
        self.genreIds = genreIds ?? []
        self.releaseNotes = releaseNotes ?? ""
        self.minimumOsVersion = minimumOsVersion ?? ""
        self.primaryGenreName = primaryGenreName ?? ""
        self.releaseDate = Date.convertAppleStringToDate(releaseDate ?? "")
        self.currency = currency ?? ""
        self.wrapperType = wrapperType ?? ""
        self.version = version ?? ""
        self.description = description ?? ""
        self.artistId = artistId ?? ""
        self.artistName = artistName ?? ""
        self.genres = genres ?? []
        self.price = price ?? 0.0
        self.bundleId = bundleId ?? ""
        self.trackId = trackId ?? ""
        self.trackName = trackName ?? ""
        self.formattedPrice = formattedPrice ?? ""
        self.averageUserRating = averageUserRating ?? 0.0
        self.userRatingCount = userRatingCount ?? 0
    }
    
}

extension KeyedDecodingContainer {
    
    /**
     Decode Safe 함수
     #매개변수
     - type: T
     - key: key
     - returns: T
     */
    func decodeSafe<T: Decodable>(_ type: T.Type, forKey key: KeyedDecodingContainer.Key) throws -> T? {
        let value = try? self.decode(T.self, forKey: key)
        
        if value != nil {
            return value
        }
        
        if let value = try? self.decode(String.self, forKey: key) {
            if T.self is Int.Type {
                return Int(value.isEmpty ? "0" : value) as? T
            } else if T.self is Int64.Type {
                return Int64(value.isEmpty ? "0" : value) as? T
            } else if T.self is Double.Type {
                return Double(value.isEmpty ? "0.0" : value) as? T
            } else if T.self is Float.Type {
                return Float(value.isEmpty ? "0.0" : value) as? T
            }
        }
        
        return nil
    }
    
    /**
     Int64 Decode Safe 함수
     #매개변수
     - key: key
     - returns: Int64 숫자
     */
    func decodeInt64(forKey key: KeyedDecodingContainer.Key) throws -> Int64 {
        if let value = try? self.decode(String.self, forKey: key) {
            return Int64(value.isEmpty ? "0" : value)!
        } else if let value = try? self.decode(Int64.self, forKey: key) {
            return Int64(value)
        } else if let value = try? self.decode(Double.self, forKey: key) {
            return Int64(value)
        } else if let value = try? self.decode(Float.self, forKey: key) {
            return Int64(value)
        }
        return 0
    }
    
    /**
     Double Decode Safe 함수
     #매개변수
     - key: key
     - returns: Double 숫자
     */
    func decodeDouble(forKey key: KeyedDecodingContainer.Key) throws -> Double {
        if let value = try? self.decode(String.self, forKey: key) {
            return Double(value.isEmpty ? "0.0" : value)!
        } else if let value = try? self.decode(Int.self, forKey: key) {
            return Double(value)
        } else if let value = try? self.decode(Double.self, forKey: key) {
            return Double(value)
        } else if let value = try? self.decode(Float.self, forKey: key) {
            return Double(value)
        }
        return 0.0
    }
    
}

extension Date {
    
    /**
     애플 날짜 형식 문자로 부터 Date 타입으로 변환 함수
     #매개변수
     - dateString: 날짜 문자열
     - returns: 날짜
     */
    static func convertAppleStringToDate(_ dateString: String?) -> Date? {
        guard let dateString = dateString else {
            return nil
        }
        if dateString.isEmpty {
            return nil
        }
        return convertStringToDate(dateString, dateFormat: "yyyy-MM-dd'T'HH:mm:ssZ")
    }
    
    /**
     애플 날짜 형식 문자로 부터 Date 타입으로 변환 함수
     #매개변수
     - dateString: 날짜 문자열
     - dateFormat: Date Format
     - returns: 날짜
     */
    static func convertStringToDate(_ dateString: String, dateFormat: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
        return dateFormatter.date(from: dateString)
    }
    
}
