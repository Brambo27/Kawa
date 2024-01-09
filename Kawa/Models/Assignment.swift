//
//  Assignment.swift
//  Kawa
//
//  Created by Bram on 25/11/2023.
//

import Foundation
import SwiftData

@Model
final class Assignment {
    @Attribute(.unique) var id: String?
    var name: String
    var deadline: Date
    var assignmentDescription: String
    var userFiles: [File]
    var subject: Subject?
    
    @Relationship(deleteRule: .nullify, inverse: \Score.assignment)
    var score: Score?
    
    init(from item: AssignmentEntity) async throws{
        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        dateFormatter.dateFormat = "dd-MM-yyyy" //TODO: This dateformat is not right for deadlines should have time
        guard let date = dateFormatter.date(from: item.deadline) else {
            throw DownloadError.wrongDataFormat(error: NSError(domain: "Could not convert date of form \(item.deadline) into Date of format \(dateFormatter.dateFormat!)", code: 0))
        }
                
        self.id = item.id
        self.name = item.assignmentDescription
        self.deadline = date
        self.assignmentDescription = ""
        self.userFiles = []
        do {
            self.userFiles = try await self.fetchFiles()
        } catch {
            print("Failed to fetch files: \(error)")
        }
    }

    init(id: String, name: String, deadline: Date, description: String, userFiles: [File]){
        self.id = id
        self.name = name
        self.deadline = deadline
        self.assignmentDescription = description
        self.userFiles = userFiles
    }
}

extension Assignment {
    static func predicate() -> Predicate<Assignment> {
        let now = Date()
        return #Predicate<Assignment> { item in
            item.deadline > now
        }
    }
}

struct AssignmentEntity: Codable{
    let id: String
    let userId: Int
    let courseId: Int
    let assignmentDescription: String
    let deadline: String
    let assignmentFile: String?
}

struct File: Codable {
    let id: Int
    let userId: Int
    let assignmentFile: String
    var fileName: String {
        return String(assignmentFile.split(separator: "/").last ?? "")
    }
}

extension Assignment {
    @MainActor
    
    func fetchFiles() async throws -> [File]{
        guard let url = URL(string: "\(URLs.uploadedAssignmentsUrl)\(self.id)") else {
            print("something went wrong")
            return []//TODO: Figure this out
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try JSONDecoder().decode([File].self, from: data)
        return result
    }
}
