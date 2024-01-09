//
//  ActivityView.swift
//  Kawa
//
//  Created by Bram on 08/01/2024.
//

import Foundation
import SwiftUI
import SwiftData

struct ActivityView: View {
    @Query(filter: ScheduleItem.predicate(isOfType: .event)) var activities: [ScheduleItem]

    var body: some View {
        Frame{
            if(activities.isEmpty){
                Text("No acitivties planned")
                    .font(Font.custom("Inter", size: 20))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
            }
            else{
                ForEach(activities){activity in
                    ActivityListItem(activity: activity)
                }
            }
        }
    }
}

struct ActivityListItem: View {
    var activity: ScheduleItem
    var body: some View {
        Card(layout: .horizontal){
            VStack(spacing: 8) {
                Text(activity.title)
                  .font(Font.custom("Inter", size: 20))
                  .foregroundColor(.black)
                  .frame(maxWidth: .infinity, alignment: .topLeading)
                
                Text(activity.dateTime, format: Date.FormatStyle().day().month().year().hour().minute())
                  .font(Font.custom("Inter", size: 12))
                  .foregroundColor(.black)
                  .frame(maxWidth: .infinity, alignment: .topLeading)
            }
            
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundStyle(Color("Primary"))
                .frame(maxHeight: .infinity)
        }
    }
}

#Preview {
    ActivityView()
}

#Preview {
    Frame{
        ActivityListItem(activity: .english)
    }
}
