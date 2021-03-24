//
//  HistoryWordUserDefaultManager.swift
//  AppStoreCloneProject
//
//  Created by MUN JEONG SEO on 2021/03/24.
//

import Foundation

class HistoryWordUserDefaultManager {
    static let shared = HistoryWordUserDefaultManager()
    private init() {}
    
    let HISTORY_WORD_DATA_KEY = "HISTORY_WORD_DATA_KEY3"
    let maxUserDefaultData: Int = 50
    
    
    // UserDefault에서 최근검색 목록 가져오기
    func getWordList() -> [String]? {
        return UserDefaults.standard.stringArray(forKey: HISTORY_WORD_DATA_KEY) ?? [String]()
    }
    
    // UserDefault에 최근검색 목록 추가 - 중복저장을 막기위해 Set 자료구조 사용
    func addWord(word:String) {
        var historyWordArray = UserDefaults.standard.stringArray(forKey: HISTORY_WORD_DATA_KEY) ?? [String]()
        if historyWordArray.count == maxUserDefaultData {
            // MaxDataLength 초과로 기존 데이터 삭제 필요
            print("기존 UserDefault 데이터 삭제")
            let lastIndex = historyWordArray.count - 1
            historyWordArray.remove(at: lastIndex)
        }
        
        var historyWordSet:Set = Set.init(historyWordArray)
        print("새 UserDefault 데이터 추가")
        historyWordSet.insert(word)
        historyWordArray = Array.init(historyWordSet)
        UserDefaults.standard.setValue(historyWordArray, forKey: HISTORY_WORD_DATA_KEY)
    }
    
    // userDefault에 최근검색 여부 확인
    func isExistWord(word:String) -> Bool {
        let historyWordArray = UserDefaults.standard.stringArray(forKey: HISTORY_WORD_DATA_KEY) ?? [String]()
        if historyWordArray.contains(word) {
            return true
        }
        return false
    }
}
