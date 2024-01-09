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
            ForEach(notifications, id: \.id){ notification in
                Card{
                    Text(notification.title)
                }
            }
        }
    }
}

#Preview {
    NotificationsView()
}
