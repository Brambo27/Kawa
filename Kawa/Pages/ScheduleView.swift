//
//  ScheduleView.swift
//  Kawa
//
//  Created by Bram on 22/11/2023.
//
import Foundation
import SwiftUI
import SwiftData

struct ScheduleView: View {
    @Environment(\.modelContext) private var modelContext
    @State var currentWeekStartDate: Date = .startOfWeek
    
    var body: some View {
        Frame {
            WeekNavigation(currentWeekStartDate: $currentWeekStartDate)
            
            deadlineList()
            
            Button(action: {
                //TODO: Navigate to activities
            }, label: {
                HStack(alignment: .center, spacing: 8) {
                    Label("Browse activities", systemImage: "ticket")
                        .font(.callout)
                        .foregroundColor(Color("OnBackground"))
                }
                .padding(8)
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.67, green: 0.93, blue: 0.86))
                .cornerRadius(4)
            })
                                
            ScheduleList(currentWeekStartDate: currentWeekStartDate)
        }
        .task {
            do {
//                try await ScheduleItemCollection.fetchSchedule(modelContext: modelContext)
                ScheduleItem.insertSampleData(modelContext: modelContext)
            }
            catch {
                print(error)
            }
        }
    }
}

struct deadlineList: View {
    @Query(
        filter: Assignment.predicate()
    ) var futureAssignments: [Assignment]

    var body: some View {
        Card() {
            VStack(alignment: .center, spacing: 0) {
                Text("Deadlines")
                    .font(.title2)
                    .foregroundColor(Color(.primary))
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .top)
            
            if(futureAssignments.isEmpty){
                Text("You have no upcoming deadlines")
                    .font(.body)
                  .multilineTextAlignment(.center)
                  .frame(maxWidth: .infinity, alignment: .top)
            }else {
                ForEach(futureAssignments, id:\.id){ assignment in
                    DeadlineItem(item: assignment)
                }
            }
        }
    }
}

struct ScheduleList: View {
    @Query private var storedSchedule: [ScheduleItem]

    init(
        currentWeekStartDate: Date = .startOfWeek
    ){
        let predicate = ScheduleItem.predicate(between: currentWeekStartDate, and: currentWeekStartDate.adding(days: 5))
        _storedSchedule = Query(filter: predicate, sort: \ScheduleItem.startTime)
    }
    
    var body: some View {
        ForEach(groupItemsByDay(items: storedSchedule).days, id: \.day) { daySchedule in
            if(daySchedule.items.count > 0){
                Card {
                    ScheduleDay(daySchedule: daySchedule)
                }
            }
        }
    }
}

struct DayHeader: View {
    let day: String
    let date: Date

    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Text(day)
              .font(
                Font.custom("Inter", size: 20)
                  .weight(.medium)
              )
              .foregroundColor(Color("Primary"))
            Text(date, format: Date.FormatStyle().year().month(.wide).day())
              .font(Font.custom("Inter", size: 10))
              .multilineTextAlignment(.center)
              .foregroundColor(Color("Pretty Grey"))
        }
        .frame(maxWidth: .infinity, alignment: .top)
    }
}

struct ScheduleItemView: View {
    let item: ScheduleItem
    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            VStack(alignment: .trailing, spacing: 8) {
                Text(item.startTime, format: Date.FormatStyle().hour().minute())
                  .font(
                    Font.custom("Inter", size: 14)
                      .weight(.medium)
                  )
                  .multilineTextAlignment(.center)
                  .foregroundColor(.black)
                
                Text(item.endTime, format: Date.FormatStyle().hour().minute())
                  .font(Font.custom("Inter", size: 14))
                  .multilineTextAlignment(.center)
                  .foregroundColor(Color(red: 0.4, green: 0.4, blue: 0.4))
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 8)
            .frame(minWidth: 75, maxWidth: 75, maxHeight: .infinity, alignment: .topTrailing)

            Rectangle()
              .foregroundColor(.clear)
              .frame(width: 2, height: 67)
              .background(Color(red: 0.93, green: 0.93, blue: 0.93))
            
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                  .font(
                    Font.custom("Inter", size: 16)
                      .weight(.medium)
                  )
                  .foregroundColor(Color("OnBackground"))
                  .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Label("Lecture room 1", systemImage: "studentdesk")
                    .font(Font.custom("Inter", size: 12))
                    .foregroundColor(Color("OnBackground"))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            
                Label(item.teacher ?? "", systemImage: "person")
                    .font(Font.custom("Inter", size: 12))
                    .foregroundColor(Color("OnBackground"))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .padding(0)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .cornerRadius(8)
    }
}

struct DeadlineItem: View {
    var item: Assignment
    var body: some View {
        HStack(alignment: .top, spacing: 4) {
            VStack(alignment: .trailing, spacing: 8) {
                Text(item.deadline, format: Date.FormatStyle().hour().minute())
                  .font(
                    Font.custom("Inter", size: 14)
                      .weight(.medium)
                  )
                  .multilineTextAlignment(.center)
                  .foregroundColor(.black)
                
                Text("View")
                  .font(Font.custom("Inter", size: 14))
                  .multilineTextAlignment(.center)
                  .foregroundColor(Color(.primary))
            }
            .padding(.horizontal, 4)
            .padding(.vertical, 8)
            .frame(minWidth: 75, maxWidth: 75, maxHeight: .infinity, alignment: .topTrailing)

            Rectangle()
              .foregroundColor(.clear)
              .frame(width: 2, height: 67)
              .background(Color(red: 0.93, green: 0.93, blue: 0.93))
            
            VStack(alignment: .leading, spacing: 4) {
                if let subject = item.subject {
                    Text(subject.courseName)
                      .font(
                        Font.custom("Inter", size: 16)
                          .weight(.medium)
                      )
                      .foregroundColor(Color("OnBackground"))
                      .frame(maxWidth: .infinity, alignment: .topLeading)
                }

                Label(item.name, systemImage: "studentdesk")
                    .font(Font.custom("Inter", size: 12))
                    .foregroundColor(Color("OnBackground"))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            
                Text(item.deadline, format: Date.FormatStyle().weekday().day().month().year())
                    .font(Font.custom("Inter", size: 12))
                    .foregroundColor(Color("OnBackground"))
                    .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .frame(maxWidth: .infinity, alignment: .topLeading)
        }
        .padding(0)
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .cornerRadius(8)
    }
}

struct ScheduleDay: View {
    var daySchedule: ScheduleItemCollection
    
    var body: some View {
        DayHeader(day: daySchedule.day, date: daySchedule.date)
        ForEach(daySchedule.items) { schedule in
                ScheduleItemView(item: schedule)
        }
    }
}

struct WeekNavigation: View {
    @Binding var currentWeekStartDate: Date
    
    var body: some View {
        Card {
            HStack(alignment: .center) {
                Button(action: {
                    currentWeekStartDate = currentWeekStartDate.adding(days: -7)
                }, label: {
                    HStack() {
                        Image(systemName: "arrow.backward")
                            .font(.system(size: 12))
                        Text("Previous")
                          .font(Font.custom("Inter", size: 12))
                          .foregroundColor(.black)
                    }
                })

                Spacer()
                
                VStack(alignment: .center, spacing: 2) {
                    Text("Current week")
                      .font(Font.custom("Inter", size: 12))
                      .foregroundColor(.black)

                    Text(currentWeekStartDate...currentWeekStartDate.adding(days:4))
                        .font(
                          Font.custom("Inter", size: 16)
                            .weight(.medium)
                        )
                        .foregroundColor(Color("Primary"))
                }
                
                Spacer()
                
                Button {
                    currentWeekStartDate = currentWeekStartDate.adding(days: 7)
                } label: {
                    HStack() {
                        Text("Next")
                          .font(Font.custom("Inter", size: 12))
                          .foregroundColor(.black)
                        Image(systemName: "arrow.right")
                            .font(.system(size: 12))
                    }
                }
            }
        }
    }
}

//#Preview {
//    ScheduleView()
//        .environmentObject(ScheduleStore())
//}
