//
//  Module.swift
//  Kawa
//
//  Created by Bram on 25/11/2023.
//

import Foundation
import SwiftData

//  {
//"id": 101,
//"moduleName": "Module 1",
//"moduleDescription": "First term module",
//"startDate": "01-08-2024",
//"endDate": "01-11-2024"
//},
@Model
class Module {
    @Attribute(.unique) let id: Int
    var moduleName: String
    var moduleDescription: String
    var startDate: String
    var endDate: String
    
    @Relationship(deleteRule: .cascade, inverse: \Subject.module)
    var subjects = [Subject]()
    
    init(id: Int, moduleName: String, moduleDescription: String, startDate: String, endDate: String) {
        self.id = id
        self.moduleName = moduleName
        self.moduleDescription = moduleDescription
        self.startDate = startDate
        self.endDate = endDate
    }
    
    init(from: ModuleEntity) async{
        self.id = from.id
        self.moduleName = from.moduleName
        self.moduleDescription = from.moduleDescription
        self.startDate = from.startDate
        self.endDate = from.endDate
    }
}

struct ModuleEntity: Codable{
    let id: Int
    let moduleName: String
    let moduleDescription: String
    let startDate: String
    let endDate: String
}

extension Array where Element == Module {
    @MainActor
    func fetchModules(modelContext: ModelContext) async throws {
        guard let url = URL(string: "https://virtserver.swaggerhub.com/Kawa-V2/Course_service/1.0.0/modules") else {
            print("something went wrong")
            return //TODO: Figure this out
        }
        
        let session = URLSession.shared
        guard let (data, response) = try? await session.data(from: url),
              let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200
        else {
            throw DownloadError.missingData
        }
        
        do {
            let items = try JSONDecoder().decode([ModuleEntity].self, from: data)
            for item in items { //TODO: remove test items
                let module = await Module(from: item)
                modelContext.insert(module)
            }
        } catch {
            throw DownloadError.wrongDataFormat(error: error)
        }
    }
}

extension Module {    
    @MainActor
    func fetchSubjects(modelContext: ModelContext) async throws -> [Subject] {
        guard let url = URL(string: "https://virtserver.swaggerhub.com/Kawa-V2/Course_service/1.0.0/modules/\(self.id)/courses") else {
            print("something went wrong")
            return []//TODO: Figure this out
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try JSONDecoder().decode([SubjectEntity].self, from: data)
        var subjects: [Subject] = []
        do{
            for subject in result {
                let subjectModel = try Subject(from: subject)
                subjects.append(subjectModel)
            }
        }catch {
            print("filed to map subjects: \(error)")
        }
        
        return subjects
    }
}
