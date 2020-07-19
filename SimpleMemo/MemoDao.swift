//
//  MemoDao.swift
//  SimpleMemo
//
//  Created by 柴田晃輔 on 2020/07/19.
//  Copyright © 2020 shibata. All rights reserved.
//

import Foundation

class MemoDao {
    static func saveMemo(_ saveData: [MemoData]) {
        let data = saveData.map { try! JSONEncoder().encode($0) }
        UserDefaults.standard.set(data as [Any], forKey: "MemoData")
    }

    static func getMemo(_ key: String) -> [MemoData]? {
        guard let data = UserDefaults.standard.array(forKey: "MemoData") as? [Data] else { return [MemoData]() }

        let decodedData = data.map { try! JSONDecoder().decode(MemoData.self, from: $0) }
        return decodedData

    }
}
