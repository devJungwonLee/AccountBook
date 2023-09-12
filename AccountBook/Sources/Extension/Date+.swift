//
//  Date+.swift
//  AccountBook
//
//  Created by 이정원 on 2023/06/05.
//

import Foundation

extension Date {
    var elapsedMinutes: Int? {
        return Calendar.current.dateComponents([.minute], from: self, to: Date()).minute
    }
    
    var toString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko")
        formatter.dateFormat = "yyyy년 M월 d일 EEEE a h:mm"
        return formatter.string(from: self)
    }
}
