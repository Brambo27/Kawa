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
            
            let testAssignments = [Assignment.presentPerfectAssignment]
            for assignment in testAssignments{ //result
//                let assignmentModel = try await Assignment(from: assignment)
//                modelContext.insert(assignmentModel)
//                assignments.append(assignmentModel)
                assignment.subject = self
                modelContext.insert(assignment)
                assignments.append(assignment)
                
            }
        }catch {
            print("Can't map assignment: \(error)")
        }

        return assignments
    }
}

extension Array where Element == Subject {
    static let test = [
        Subject(courseId: 1, courseName: "English", courseDescription: "English Class", teacherName: "Nyange", startDate: Date().adding(days: -14), endDate: Date().adding(days: 60)),
        Subject(courseId: 2, courseName: "Math", courseDescription: "Math Class", teacherName: "Nyange", startDate: Date().adding(days: -14), endDate: Date().adding(days: 60)),
        Subject(courseId: 3, courseName: "Science", courseDescription: "Science Class", teacherName: "Nyange", startDate: Date().adding(days: -14), endDate: Date().adding(days: 60)),
        Subject(courseId: 4, courseName: "History", courseDescription: "History Class", teacherName: "Nyange", startDate: Date().adding(days: -14), endDate: Date().adding(days: 60)),
        Subject(courseId: 5, courseName: "Geography", courseDescription: "Geography Class", teacherName: "Nyange", startDate: Date().adding(days: -14), endDate: Date().adding(days: 60)),
    ]
}
