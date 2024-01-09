//
//  SampleData+Subject.swift
//  Kawa
//
//  Created by Bram on 20/12/2023.
//

import Foundation

extension Subject {
    static let english = Subject(courseId: 1, courseName: "English", courseDescription: "English Class", teacherName: "Nyange", startDate: Date().adding(days: -14), endDate: Date().adding(days: 60))
//    static let computerSkills = Subject(courseId: 2, courseName: "Computer Skills", courseDescription: "Computer Skills", teacherName: "Nyange", startDate: Date().adding(days: -14), endDate: Date().adding(days: 60))
//    static let mathematics = Subject(courseId: 3, courseName: "Mathematics", courseDescription: "Mathematics", teacherName: "Nyange", startDate: Date().adding(days: -14), endDate: Date().adding(days: 60))
}
