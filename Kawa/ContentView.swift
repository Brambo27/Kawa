//
//  ContentView.swift
//  Kawa
//
//  Created by Bram on 22/11/2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @StateObject var scheduleStore: ScheduleStore
    @State private var tabSelection = "Home"
    @State private var showPaymentView = false
    
    var body: some View {
        TabView(selection: $tabSelection) {
            NavigationStack{
                HomeView(tabSelection: $tabSelection, showPaymentView: $showPaymentView)
            }.tabItem {
                Label("Home", systemImage: "house")
            }.tag("Home")
            NavigationStack {
                SubjectsView()
            }.tabItem {
                Label("Subjects", systemImage: "graduationcap")
            }
            .tag("Subjects")
            NavigationStack{
                ScheduleView()
                    .environmentObject(scheduleStore)
            }.tabItem {
                Label("Schedule", systemImage: "calendar")
            }.tag("Schedule")
            
            NotificationsView()
                .tabItem {
                    Label("Notifications", systemImage: "bell")
                }
            NavigationStack(){
                ProfileView()
                    .navigationDestination(isPresented: $showPaymentView) {
                        PaymentView().navigationViewStyle(.stack)
                    }
                   
            }.tabItem {
                Label("Profile", systemImage: "person")
            }.tag("Profile")
        }
    }
}

//#Preview {
//    var scheduleStore = ScheduleStore()
//    return ContentView(scheduleStore: scheduleStore)
//        .modelContainer(for: ScheduleItem.self, inMemory: true)
//}
