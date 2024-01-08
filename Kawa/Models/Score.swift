//
//  Grade.swift
//  Kawa
//
//  Created by Bram on 28/11/2023.
//

import Foundation
import SwiftData

@Model
class Score{
    var id: Int
    var score: Int
    var isPass: Bool
    var createdAt: Date
    
    @Relationship(deleteRule: .cascade)
    var subject: Subject?
    var assignment: Assignment?
    
    init(id: Int, score: Int, isPass: Bool, createdAt: Date) {
        self.id = id
        self.score = score
        self.isPass = isPass
        self.createdAt = createdAt
    }
}

extension Score {
    static var test = Score(id: 1, score: 86, isPass: true, createdAt: Date().adding(days: -1))
    static var test2 = Score(id: 2, score: 47, isPass: false, createdAt: Date().adding(days: -2))
}
