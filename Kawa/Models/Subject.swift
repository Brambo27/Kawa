//
//  Subject.swift
//  Kawa
//
//  Created by Bram on 25/11/2023.
//

import Foundation
import SwiftData

//{
//  "courseId": 101,
//  "courseName": "ICT",
//  "courseDescription": "A survey of philosophical problems.",
//  "teacherName": "Ben",
//  "startDate": "01-08-2024",
//  "endDate": "01-06-2025"
//}
struct SubjectEntity: Codable{
    let courseId: Int
    let courseName: String
    let courseDescription: String
    let teacherName: String
    let startDate: String
    let endDate: String
}

@Model
class Subject {
    @Attribute(.unique) let courseId: Int?
    let courseName: String
    let courseDescription: String
    let teacherName: String
    let startDate: Date
    let endDate: Date
    var module: Module?
    
    @Relationship(deleteRule: .cascade, inverse: \Assignment.subject)
    var openAssignments: [Assignment] = [Assignment]()
    
    @Relationship(deleteRule: .cascade, inverse: \Assignment.subject)
    var closedAssignments: [Assignment] = [Assignment]()

    init(from item: SubjectEntity) throws{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-mm-yyyy"
        guard let startDate = dateFormatter.date(from: item.startDate) else {
            throw NSError(domain: "Date conversion failed", code: 0)
        }
        guard let endDate = dateFormatter.date(from: item.endDate) else {
            throw NSError(domain: "Date conversion failed", code: 0)
        }
        
        self.courseId = item.courseId
        self.courseName = item.courseName
        self.courseDescription = item.courseDescription
        self.teacherName = item.teacherName
        self.startDate = startDate
        self.endDate = endDate
    }

    init(courseId: Int, courseName: String, courseDescription: String, teacherName: String, startDate: Date, endDate: Date){
        self.courseId = courseId
        self.courseName = courseName
        self.courseDescription = courseDescription
        self.teacherName = teacherName
        self.startDate = startDate
        self.endDate = endDate
    }
}

extension Subject{
    @MainActor
    func fetchAssignments(modelContext: ModelContext) async throws -> [Assignment]{
        guard let url = URL(string: "https://virtserver.swaggerhub.com/Kawa-V2/Assignment_service/1.0.0/assignments/\(self.courseId)") else {
            print("something went wrong")
            return []//TODO: Figure this out
        }
            
        var assignments: [Assignment] = []
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let result = try JSONDecoder().decode([AssignmentEntity].self, from: data)
            
            for assignment in result{
                let assignmentModel = try await Assignment(from: assignment)
                //TODO: Check if need to add to subject too, as relation
                modelContext.insert(assignmentModel)
                assignments.append(assignmentModel)
            }
        }catch {
            print("Can't map assignment: \(error)")
        }

        return assignments
    }
}
