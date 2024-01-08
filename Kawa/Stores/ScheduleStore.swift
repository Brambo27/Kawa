//
//  ScheduleStore.swift
//  Kawa
//
//  Created by Bram on 22/11/2023.
//

import Foundation
import SwiftData

@MainActor
class ScheduleStore: ObservableObject {
    private var currentWeekStart: Date = .startOfWeek
    
    func nextWeek() {
        currentWeekStart = currentWeekStart.adding(days: 7)
    }

    func previousWeek() {
        currentWeekStart = currentWeekStart.adding(days: -7)
    }
}
