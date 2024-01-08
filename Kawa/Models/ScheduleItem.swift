//
//  ScheduleItem.swift
//  Kawa
//
//  Created by Bram on 22/11/2023.
//

import Foundation
import SwiftData

@Model
class ScheduleItem {
    @Attribute(.unique) var id: Int
    var classId: Int
    var title: String
    var groupId: Int
    var dateTime: Date
    var startTime: Date
    var endTime: Date
    var courseId: Int
    var teacher: String?
    var type: String //Would like to use enum here but not supported by swiftdata yet
    var location: String?

    init(id: Int, classId: Int, title: String, groupId: Int, dateTime: Date, courseId: Int, teacher: String?, type: String, location: String?) {
        let calendar = Calendar.current
        let endTime = calendar.date(byAdding: .minute, value: 90, to: dateTime) //TODO: Get endtime from api
        
        self.id = id
        self.classId = classId
        self.title = title
        self.groupId = groupId
        self.dateTime = dateTime
        self.startTime = dateTime
        self.endTime = endTime ?? Date()
        self.courseId = courseId
        self.teacher = teacher
        self.type = type /*ScheduleItemType(rawValue: type) ?? .lesson*/
        self.location = location
    }

    convenience init(from item: ScheduleItemEntity) throws{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        guard let date = dateFormatter.date(from: item.createdAt) else {
            throw NSError(domain: "Date conversion failed", code: 0)
        }
                
        self.init(
            id: item.id,
            classId: item.classId,
            title: item.title,
            groupId: item.groupId,
            dateTime: date,
            courseId: item.courseId,
            teacher: item.teacher,
            type: item.scheduleItemType,
            location: item.location
        )
    }
}

extension ScheduleItem {
    static func predicate(
        searchDate: Date
    ) -> Predicate<ScheduleItem> {
        let calendar = Calendar.autoupdatingCurrent
        let start = calendar.startOfDay(for: searchDate)
        let end = calendar.date(byAdding: .init(day: 1), to: start) ?? start //TODO: Check if this is just 24 hours instead of today

        return #Predicate<ScheduleItem> { item in
            (item.dateTime > start && item.dateTime < end)
        }
    }
    
    static func predicate(
        between: Date,
        and: Date
    ) -> Predicate<ScheduleItem> {
        return #Predicate<ScheduleItem> { item in
            (item.dateTime > between && item.dateTime < and)
        }
    }
    
    static func predicate(
        isOfType: ScheduleItemType
    ) -> Predicate<ScheduleItem> {
            return #Predicate<ScheduleItem> { item in
                item.type == isOfType.rawValue
            }
        }
}

enum ScheduleItemType: String, Codable, Hashable {
    case job = "job"
    case lesson = "lesson"
    case event = "event"
    case announcement = "announcement"
}

struct ScheduleItemEntity: Codable {
    let id: Int
    let classId: Int
    let title: String
    let groupId: Int
    let createdAt: String
    let courseId: Int
    let teacher: String
    let scheduleItemType: String
    let location: String
}

extension ScheduleItem {
    static func map(from entity: ScheduleItemEntity) throws -> ScheduleItem {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        guard let date = dateFormatter.date(from: entity.createdAt) else {
            throw NSError(domain: "Date conversion failed", code: 0)
        }
        
        return ScheduleItem(id: entity.id, classId: entity.classId, title: entity.title, groupId: entity.groupId, dateTime: date, courseId: entity.courseId, teacher: entity.teacher, type: entity.scheduleItemType, location: entity.location)
    }
}

struct WeeklySchedule {
    var days: [ScheduleItemCollection]
}

func groupItemsByDay(items: [ScheduleItem]) -> WeeklySchedule {
    var weeklySchedule = WeeklySchedule(
        days: [
            ScheduleItemCollection(day: "Monday", date: Date(), items: []),
            ScheduleItemCollection(day: "Tuesday", date: Date(), items: []),
            ScheduleItemCollection(day: "Wednesday", date: Date(), items: []),
            ScheduleItemCollection(day: "Thursday", date: Date(), items: []),
            ScheduleItemCollection(day: "Friday", date: Date(), items: []),
            ScheduleItemCollection(day: "Saturday", date: Date(), items: []),
            ScheduleItemCollection(day: "Sunday", date: Date(), items: [])
        ]
    )
    
    for item in items {
        let dayOfWeek = Calendar.current.component(.weekday, from: item.dateTime)
        
        let dayIndex = (dayOfWeek + 5) % 7 // Adjust for 1-based weekday index
        
        weeklySchedule.days[dayIndex].date = item.dateTime
        weeklySchedule.days[dayIndex].items.append(item)
    }
    
    return weeklySchedule
}
