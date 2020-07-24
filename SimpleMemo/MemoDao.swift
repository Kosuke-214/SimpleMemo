//
//  MemoDao.swift
//  SimpleMemo
//
//  Created by 柴田晃輔 on 2020/07/19.
//  Copyright © 2020 shibata. All rights reserved.
//

import Foundation

class MemoDao {

    static let MEMO_DATA = "MemoData"
    static let SAVED_FLG = "savedFlg"

    static func saveMemo(_ saveData: Dictionary<String?, MemoData>) {

        let saveDataArray = Array(saveData.values)

        let data = saveDataArray.map { try! JSONEncoder().encode($0) }
        UserDefaults.standard.set(data as [Any], forKey: MEMO_DATA)
    }

    static func getMemo(_ key: String) -> Dictionary<String?, MemoData>? {
        var memoData = Dictionary<String?, MemoData>()

        guard let data = UserDefaults.standard.array(forKey: MEMO_DATA) as? [Data] else { return memoData }

        let decodedData = data.map { try! JSONDecoder().decode(MemoData.self, from: $0) }

        let group = Dictionary(grouping: decodedData) { $0.id }

        for (key, value) in group {
            memoData[key] = value[0]
        }
        return memoData

    }

    static func saveSavedFlg(_ flg: Bool) {
        UserDefaults.standard.set(flg, forKey: SAVED_FLG)
    }

    static func isSavedFlg() -> Bool {
        return UserDefaults.standard.bool(forKey: SAVED_FLG)
    }
}
