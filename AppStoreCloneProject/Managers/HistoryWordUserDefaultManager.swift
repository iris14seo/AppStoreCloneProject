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
    
    let HISTORY_WORD_DATA_KEY = "HISTORY_WORD_DATA_KEY"
    
    // UserDefault에서 최근검색 목록 가져오기
    func getWordList() -> [String]? {
        return UserDefaults.standard.stringArray(forKey: HISTORY_WORD_DATA_KEY) ?? [String]()
    }
    
    // UserDefault에 최근검색 목록 추가
    // 중복저장을 막기위해 Set 자료구조 사용
    func addWord(word:String) {
        var historyWordArray = UserDefaults.standard.stringArray(forKey: HISTORY_WORD_DATA_KEY) ?? [String]()
        var historyWordSet:Set = Set.init(historyWordArray)
        historyWordSet.insert(word)
        historyWordArray = Array.init(historyWordSet)
        UserDefaults.standard.setValue(historyWordArray, forKey: HISTORY_WORD_DATA_KEY)
    }
    
    // UserDefault에 최근검색 목록 제거
    func removeWord(word:String) {
        var historyWordArray = UserDefaults.standard.stringArray(forKey: HISTORY_WORD_DATA_KEY) ?? [String]()
        historyWordArray = historyWordArray.filter({
            return $0 != word
        })
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
