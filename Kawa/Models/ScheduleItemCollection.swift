//
//  ScheduleItemCollection.swift
//  Kawa
//
//  Created by Bram on 24/11/2023.
//

import Foundation
import SwiftData

struct ScheduleItemCollection {
    var day: String
    var date: Date
    var items: [ScheduleItem]
}

extension ScheduleItemCollection{
    
    @MainActor
    static func fetchSchedule(modelContext: ModelContext) async throws {
        guard let url = URL(string: URLs.scheduleUrl) else { //TODO: Have a look at the date range
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
            let items = try JSONDecoder().decode([ScheduleItemEntity].self, from: data)
            
            for item in items {
                let scheduleItem = try ScheduleItem(from: item)
                modelContext.insert(scheduleItem)
            }
        } catch {
            throw DownloadError.wrongDataFormat(error: error)
        }
    }
}
