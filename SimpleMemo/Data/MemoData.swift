//
//  MemoData.swift
//  SimpleMemo
//
//  Created by 柴田晃輔 on 2020/07/19.
//  Copyright © 2020 shibata. All rights reserved.
//

import Foundation

struct MemoData: Codable {
    let id: String?
    var title: String?
    var content: String?
    var date: String?
}
