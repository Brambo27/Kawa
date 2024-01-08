//
//  SampleData+Module.swift
//  Kawa
//
//  Created by Bram on 20/12/2023.
//

import Foundation
import SwiftData

extension Module {
    static let module1 = Module(id: 1, moduleName: "Module 1", moduleDescription: "Module 1", startDate: "08-05-1999", endDate: "08-05-2024")
    static let module2 = Module(id: 2, moduleName: "Module 2", moduleDescription: "Module 2", startDate: "08-05-1999", endDate: "08-05-2024")
    
    static func insertSampleData(modelContext: ModelContext) {
        DispatchQueue.main.async {
            modelContext.insert(module1)
            modelContext.insert(module2)
            try? modelContext.save()
        }
    
        Subject.english.module = module1
        Subject.english.openAssignments = [.presentPerfectAssignment]
    }
    
    static func reloadSampleData(modelContext: ModelContext) {
        do {
            try modelContext.delete(model: Module.self)
            insertSampleData(modelContext: modelContext)
        } catch {
            fatalError(error.localizedDescription)
        }
    }
}
