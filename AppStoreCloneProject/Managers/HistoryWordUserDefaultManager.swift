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
    
    let HISTORY_WORD_DATA_KEY = "LOCAL_HISTORY_WORD_DATA_KEY"
    let dataLimitCount: Int = 30
    
    // UserDefault에서 최근검색 목록 가져오기
    func getDataList() -> [String]? {
        return UserDefaults.standard.stringArray(forKey: HISTORY_WORD_DATA_KEY) ?? [String]()
    }
    
    // UserDefault에 최근검색어 추가 - 중복저장을 막아야함, 순서 필요
    func addData(word:String) {
        // (1) 존재하는 데이터 인지 확인 -> 데이터 위치변경
        // (2) maxLength 채웠나 확인 -> 추가 OR 제일 오래된것 삭제 + 추가
        
        var historyWordArray = UserDefaults.standard.stringArray(forKey: HISTORY_WORD_DATA_KEY) ?? [String]()
        
        if isExistData(word: word) {
            //데이터 위치만 변경
            historyWordArray.move(word, to: 0)
        } else {
            //데이터 추가
            if isMeetALimit() {
                print("기존 UserDefault 데이터 삭제")
                let lastIndex = historyWordArray.count - 1 //제일 고대의 것
                historyWordArray.remove(at: lastIndex)
            }
            
            historyWordArray.insert(word, at: 0)
        }
        
        UserDefaults.standard.setValue(historyWordArray, forKey: HISTORY_WORD_DATA_KEY)
    }
    
    // UserDefault에 데이터 이미 들어있는지 확인
    func isExistData(word:String) -> Bool {
        let historyWordArray = UserDefaults.standard.stringArray(forKey: HISTORY_WORD_DATA_KEY) ?? [String]()
        if historyWordArray.contains(word) {
            return true
        }
        return false
    }
    
    // UserDefault에 Limit 까지 데이터 들어있나 확인
    func isMeetALimit() -> Bool {
        let historyWordArray = UserDefaults.standard.stringArray(forKey: HISTORY_WORD_DATA_KEY) ?? [String]()
        if historyWordArray.count == self.dataLimitCount {
            return true
        }
        return false
    }
    
    // UserDefault의 데이터 전체 삭제
    func removeAllData() {
        UserDefaults.standard.removeObject(forKey: HISTORY_WORD_DATA_KEY)
    }
}

extension Array where Element: Equatable {
    mutating func move(_ element: Element, to newIndex: Index) {
        if let oldIndex: Int = self.firstIndex(of: element) { self.move(from: oldIndex, to: newIndex) }
    }
}

extension Array {
    mutating func move(from oldIndex: Index, to newIndex: Index) {
        // Don't work for free and use swap when indices are next to each other - this
        // won't rebuild array and will be super efficient.
        if oldIndex == newIndex { return }
        if abs(newIndex - oldIndex) == 1 { return self.swapAt(oldIndex, newIndex) }
        self.insert(self.remove(at: oldIndex), at: newIndex)
    }
}
