//
//  Date+Adding.swift
//  Kawa
//
//  Created by Bram on 25/11/2023.
//

import Foundation

extension Date{
    func adding(days: Int) -> Date{
        Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    public static var startOfWeek: Date {
        Calendar(identifier: .iso8601).date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: .now))!
    }
}
