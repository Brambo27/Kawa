//
//  KawaApp.swift
//  Kawa
//
//  Created by Bram on 22/11/2023.
//

import SwiftUI
import SwiftData

@main
struct KawaApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([ScheduleItem.self, Module.self, Payment.self])
    
    let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
    do {
        return try ModelContainer(for: schema, configurations: [modelConfiguration])
    }catch{
        fatalError("Could not create ModelContainer: \(error)")
    }
}()
    
    var body: some Scene {
        WindowGroup {
            ContentView(scheduleStore: ScheduleStore())
        }.modelContainer(sharedModelContainer)
    }
}
