//
//  HomePage.swift
//  Kawa
//
//  Created by Bram on 22/11/2023.
//

import Foundation
import SwiftUI
import SwiftData

struct HomeView: View {
    @Binding var tabSelection: String
    @Binding var showPaymentView: Bool
    @Environment(\.modelContext) private var modelContext
    
    var body: some View{
        Frame {
            Tiles(tabSelection: $tabSelection, showPaymentView: $showPaymentView)
            
            Schedule()
            
        }.task {
//            try? await ScheduleItemCollection.fetchSchedule(modelContext: modelContext)
            
//            modelContext.insert(Assignment.test)
//            modelContext.insert(Subject.english)
//            modelContext.insert(Score.test)
//            modelContext.insert(Score.test2)
        }
    }
}

struct Tiles: View{
    @Binding var tabSelection: String
    @Binding var showPaymentView: Bool
    @State var isTapped = false
    @State var progress: PaymentProgress?
    
    var body: some View{
        Grid(horizontalSpacing: 12, verticalSpacing: 12) {
            GridRow {
                NavigationLink{
                    
                } label:{
                    Card(cardColor: Color("Primary"), isSquare: true) {
                        Text("Notification")
                            .font(.headline)
                          .multilineTextAlignment(.center)
                          .foregroundStyle(Color(.white))
                        Spacer()
                    }
                }
                
                Button{
                    tabSelection = "Profile"
                    showPaymentView = true
                } label:{
                    Card(isSquare: true){
                        VStack(alignment: .center){
                            Text("Payment status")
                                .font(.headline)
                                .multilineTextAlignment(.center)
                            Spacer()
                            if let progress{
                                VStack(spacing: 8){
                                    Text("Progress")
                                        .font(.body)
                                    Text("\(Int((Double(progress.paid)/Double(progress.fee))*100))%")
                                        .font(.title2.weight(.medium))
                                }
                                Spacer()
                                ProgressView("\(progress.paid) / \(progress.fee)", value: Double(progress.paid), total: Double(progress.fee))
                                    .tint(Color("Primary"))
                                    .font(.footnote)
                            }else{
                                ProgressView()
                                Spacer()
                            }
                        }
                    }.task {
                        do{
                            progress = try await PaymentOverview.fetchPaymentProgress()
                        }catch {
                            print("something went wrong while fetching payment progress in homeview")
                        }
                    }
                }.foregroundStyle(Color(.black))
            }
            GridRow {
                Button{
                    tabSelection = "Schedule"
                } label:{
                    Card(isSquare: true){
                        VStack(alignment: .leading){
                            Text("Schedule")
                                .frame(maxWidth: .infinity, alignment: .top)
                                .font(.headline)
                                .foregroundStyle(Color(.black))
                            
                            Spacer()
                            NextScheduleItem()
                        }
                    }
                }.foregroundStyle(Color(.black))
                
                ScoreTile()
            }
        }
    }
}

struct ScoreTile: View {
    @Query(sort: \Score.createdAt, order: .reverse) var scores: [Score]
    
    var body: some View {
        Card(cardColor: Color("Secondary"), isSquare: true){
            VStack(alignment: .center, spacing: 13){
                
                Text("Scores")
                    .font(.headline)
                  .multilineTextAlignment(.center)
                
                if let score = scores.first{
                    VStack{
                        Text(score.subject?.courseName ?? "")
                            .font(.callout)
                            .fontWeight(.medium)
                        Text(score.assignment?.name ?? "")
                            .foregroundStyle(Color.prettyGrey)
                    }

                    ZStack{
                        Circle()
                            .stroke(Color.accent, lineWidth: 4)
                            .fill(Color.white)
                            .frame(width: 50, height: 50)
//                            .backgroundStyle(Color("Accent"))
                        Text("\(score.score)")
                            .font(.title3)
                            .bold()
                    }
                }else {
                    Text("Your latest score will be displayed here")
                }
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
    }
}

struct NextScheduleItem: View {
    @Query(
        filter: ScheduleItem.predicate(between: Date(), and: Date.distantFuture),
        sort: \ScheduleItem.startTime
    ) var todaysSchedule: [ScheduleItem]
    
    var body: some View {
        if let nextScheduleItem = todaysSchedule.first{

            VStack(alignment: .leading, spacing: 4){
                Text(nextScheduleItem.title)
                    .fontWeight(.medium)
                    .frame(maxWidth: .infinity, alignment: .top)
                Label(nextScheduleItem.location ?? "", systemImage: "studentdesk")
                    .font(Font.custom("Inter", size: 12))
                Label(nextScheduleItem.teacher ?? "", systemImage: "person")
                    .font(Font.custom("Inter", size: 12))
            }
            Spacer()
            Text(nextScheduleItem.startTime...nextScheduleItem.endTime)
                .frame(maxWidth: .infinity, alignment: .top)
                .font(Font.custom("Inter", size: 14))
        }
    }
}

struct Schedule: View {
    @Environment(\.modelContext) private var modelContext
    @Query(
        filter: ScheduleItem.predicate(searchDate: Date())
    ) var todaysSchedule: [ScheduleItem]

    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("My schedule")
              .font(
                Font.custom("Inter", size: 18)
                  .weight(.medium)
              )
              .foregroundColor(Color(red: 0.39, green: 0.16, blue: 0.82))
        }
        .padding(0)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        
        Card {
            DayHeader(day: "Today", date: Date())
            
            if todaysSchedule.count != 0 {
                ForEach(todaysSchedule) { schedule in
                    ScheduleItemView(item: schedule)
                }
            }else {
                ContentUnavailableView {
                    Label("You have no classes scheduled for today", systemImage: "calendar")
                        .font(.headline)
                } description: {
                    Text("When you have classes scheduled for today they will appear here.")
                }
            }
        }.task {
            if(todaysSchedule.isEmpty){
                //try await ScheduleItemCollection.fetchSchedule(modelContext: modelContext)
                ScheduleItem.insertSampleData(modelContext: modelContext)
            }
        }
    }
}
#Preview {
    @State var tabSelection = "Home"
    @State var showPaymentView = false

    return HomeView(tabSelection: $tabSelection, showPaymentView: $showPaymentView)
        .modelContainer(for: [ScheduleItem.self, Score.self], inMemory: true)
}
