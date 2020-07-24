//
//  Util.swift
//  SimpleMemo
//
//  Created by 柴田晃輔 on 2020/07/23.
//  Copyright © 2020 shibata. All rights reserved.
//

import Foundation

class Util {
    func idGenerator() -> String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var randomString = ""

        for _ in 0 ..< 10 {
            randomString += String(letters.randomElement()!)
        }

        return randomString
    }

    func nowDate() -> String {
        let f = DateFormatter()
        f.dateStyle = .medium
        f.timeStyle = .medium
        f.locale = Locale(identifier: "ja_JP")
        let now = Date()
        return f.string(from: now)
    }
}
