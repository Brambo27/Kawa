//
//  NotificationsView.swift
//  Kawa
//
//  Created by Bram on 22/11/2023.
//

import Foundation
import SwiftUI
import SwiftData

struct NotificationsView: View {
    @Query(filter: ScheduleItem.predicate(isOfType: .announcement)) var notifications: [ScheduleItem]
    
    var body: some View {
        Frame{
            Card{
                ForEach(notifications, id: \.id){ notification in
                    Text(notification.title)
                }
                Text("NotificationsView")
            }
        }
    }
}

#Preview {
    NotificationsView()
}
