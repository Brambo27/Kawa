//
//  SampleData+Schedule.swift
//  Kawa
//
//  Created by Bram on 07/01/2024.
//

import Foundation
import SwiftData

extension ScheduleItem{
    public static var english = ScheduleItem(id: 3, classId: 1, title: "English", groupId: 1, dateTime: Date.startOfWeek.advanced(by: 60*240), courseId: 1, teacher: "Suzanne", type: "lesson", location: "Lecture room 1")
}

extension Array where Element == ScheduleItem {
    static let sampleData: [ScheduleItem] = {
        [
            ScheduleItem(id: 24, classId: 1, title: "Entrepreneurial Skills", groupId: 1, dateTime: Date.startOfWeek.adding(days: -3), courseId: 1, teacher: "Nyange", type: "lesson", location: "Lecture room 1"),
            ScheduleItem(id: 25, classId: 1, title: "Entrepreneurial Skills", groupId: 1, dateTime: Date.startOfWeek.adding(days: -3).advanced(by: 60*120), courseId: 1, teacher: "Nyange", type: "lesson", location: "Lecture room 1"),
            ScheduleItem(id: 26, classId: 1, title: "E-learning", groupId: 1, dateTime: Date.startOfWeek.adding(days: -3).advanced(by: 60*240), courseId: 1, teacher: "Nyange", type: "lesson", location: "Lecture room 1"),
            ScheduleItem(id: 27, classId: 1, title: "Girls Club/ Guys Club", groupId: 1, dateTime: Date.startOfWeek.adding(days: -3).advanced(by: 60*300), courseId: 1, teacher: "Nyange", type: "lesson", location: "Lecture room 1"),
            ScheduleItem(id: 1, classId: 1, title: "Enviroment", groupId: 1, dateTime: Date.startOfWeek.advanced(by: 1), courseId: 1, teacher: "Suzanne", type: "lesson", location: "Lecture room 1"),
            ScheduleItem(id: 2, classId: 1, title: "E-learning", groupId: 1, dateTime: Date.startOfWeek.advanced(by: 60*120), courseId: 1, teacher: "Suzanne", type: "lesson", location: "Lecture room 1"),
            ScheduleItem(id: 3, classId: 1, title: "English", groupId: 1, dateTime: Date.startOfWeek.advanced(by: 60*240), courseId: 1, teacher: "Suzanne", type: "lesson", location: "Lecture room 1"),
            ScheduleItem(id: 4, classId: 1, title: "Computer Skills", groupId: 1, dateTime: Date.startOfWeek.advanced(by: 60*300), courseId: 1, teacher: "Suzanne", type: "lesson", location: "Lecture room 1"),
            ScheduleItem(id: 5, classId: 1, title: "Computer Skills", groupId: 1, dateTime: Date.startOfWeek.adding(days: 1), courseId: 1, teacher: "Suzanne", type: "lesson", location: "Lecture room 1"),
            ScheduleItem(id: 6, classId: 1, title: "Product Development", groupId: 1, dateTime: Date.startOfWeek.adding(days: 1).advanced(by: 60*195), courseId: 1, teacher: "Suzanne", type: "lesson", location: "Lecture room 1"),
            ScheduleItem(id: 7, classId: 1, title: "Product Development", groupId: 1, dateTime: Date.startOfWeek.adding(days: 1).advanced(by: 60*300), courseId: 1, teacher: "Suzanne", type: "lesson", location: "Lecture room 1"),
            ScheduleItem(id: 8, classId: 1, title: "Computer Skills", groupId: 1, dateTime: Date.startOfWeek.adding(days: 2), courseId: 1, teacher: "Suzanne", type: "lesson", location: "Lecture room 1"),
            ScheduleItem(id: 9, classId: 1, title: "English", groupId: 1, dateTime: Date.startOfWeek.adding(days: 2).advanced(by: 60*120), courseId: 1, teacher: "Suzanne", type: "lesson", location: "Lecture room 1"),
            ScheduleItem(id: 10, classId: 1, title: "Marketing", groupId: 1, dateTime: Date.startOfWeek.adding(days: 2).advanced(by: 60*195), courseId: 1, teacher: "Suzanne", type: "lesson", location: "Lecture room 1"),
            ScheduleItem(id: 11, classId: 1, title: "Marketing", groupId: 1, dateTime: Date.startOfWeek.adding(days: 2).advanced(by: 60*300), courseId: 1, teacher: "Suzanne", type: "lesson", location: "Lecture room 1"),
            ScheduleItem(id: 12, classId: 1, title: "English", groupId: 1, dateTime: Date.startOfWeek.adding(days: 3), courseId: 1, teacher: "Suzanne", type: "lesson", location: "Lecture room 1"),
            ScheduleItem(id: 13, classId: 1, title: "Mathematics", groupId: 1, dateTime: Date.startOfWeek.adding(days: 3).advanced(by: 60*120), courseId: 1, teacher: "Suzanne", type: "lesson", location: "Lecture room 1"),
            ScheduleItem(id: 14, classId: 1, title: "Career Development", groupId: 1, dateTime: Date.startOfWeek.adding(days: 3).advanced(by: 60*195), courseId: 1, teacher: "Suzanne", type: "lesson", location: "Lecture room 1"),
            ScheduleItem(id: 15, classId: 1, title: "Computer Skills", groupId: 1, dateTime: Date.startOfWeek.adding(days: 3).advanced(by: 60*300), courseId: 1, teacher: "Suzanne", type: "lesson", location: "Lecture room 1"),
            ScheduleItem(id: 16, classId: 1, title: "Entrepreneurial Skills", groupId: 1, dateTime: Date.startOfWeek.adding(days: 4), courseId: 1, teacher: "Nyange", type: "lesson", location: "Lecture room 1"),
            ScheduleItem(id: 17, classId: 1, title: "Entrepreneurial Skills", groupId: 1, dateTime: Date.startOfWeek.adding(days: 4).advanced(by: 60*120), courseId: 1, teacher: "Nyange", type: "lesson", location: "Lecture room 1"),
            ScheduleItem(id: 18, classId: 1, title: "E-learning", groupId: 1, dateTime: Date.startOfWeek.adding(days: 4).advanced(by: 60*240), courseId: 1, teacher: "Nyange", type: "lesson", location: "Lecture room 1"),
            ScheduleItem(id: 19, classId: 1, title: "Girls Club/ Guys Club", groupId: 1, dateTime: Date.startOfWeek.adding(days: 4).advanced(by: 60*300), courseId: 1, teacher: "Nyange", type: "lesson", location: "Lecture room 1"),
            ScheduleItem(id: 20, classId: 1, title: "Enviroment", groupId: 1, dateTime: Date.startOfWeek.adding(days:11), courseId: 1, teacher: "Suzanne", type: "lesson", location: "Lecture room 1"),
            ScheduleItem(id: 21, classId: 1, title: "E-learning", groupId: 1, dateTime: Date.startOfWeek.adding(days:11).advanced(by: 60*120), courseId: 1, teacher: "Suzanne", type: "lesson", location: "Lecture room 1"),
            ScheduleItem(id: 22, classId: 1, title: "English", groupId: 1, dateTime: Date.startOfWeek.adding(days:11).advanced(by: 60*240), courseId: 1, teacher: "Suzanne", type: "lesson", location: "Lecture room 1"),
            ScheduleItem(id: 23, classId: 1, title: "Computer Skills", groupId: 1, dateTime: Date.startOfWeek.adding(days:11).advanced(by: 60*300), courseId: 1, teacher: "Suzanne", type: "lesson", location: "Lecture room 1"),
            ScheduleItem(id: 24, classId: 1, title: "Assignment Due Tomorrow", groupId: 1, dateTime: Date.startOfWeek.adding(days: -3), courseId: 1, teacher: nil, type: "announcement", location: nil)
        ]
    }()
}

extension ScheduleItemCollection {
    static let today = ScheduleItemCollection(day: "Today", date: Date(), items: [
        ScheduleItem(id: 1, classId: 1, title: "Enviroment", groupId: 1, dateTime: Date(), courseId: 1, teacher: "Suzanne", type: "lesson", location: "Lecture room 1"),
        ScheduleItem(id: 2, classId: 1, title: "Environment", groupId: 1, dateTime: Date(), courseId: 1, teacher: "Suzanne", type: "lesson", location: "Lecture room 1"),
        ScheduleItem(id: 3, classId: 1, title: "E-learning", groupId: 1, dateTime: Date(), courseId: 1, teacher: "Suzanne", type: "lesson", location: "Lecture room 1"),
        ScheduleItem(id: 4, classId: 1, title: "English", groupId: 1, dateTime: Date(), courseId: 1, teacher: "Suzanne", type: "lesson", location: "Lecture room 1"),
    ])
}

extension ScheduleItem{
    static func insertSampleData(modelContext: ModelContext) {
        do {
            try modelContext.delete(model: ScheduleItem.self)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        DispatchQueue.main.async {
            for scheduleItem in Array<ScheduleItem>.sampleData {
                modelContext.insert(scheduleItem)
            }
            
            let today = ScheduleItemCollection(day: "Today", date: Date(), items: ])
            try? modelContext.save()
        }
    }

    static func reloadSampleData(modelContext: ModelContext) {
        insertSampleData(modelContext: modelContext)
    }
}
