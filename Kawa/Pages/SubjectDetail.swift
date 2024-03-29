//
//  SubjectDetail.swift
//  Kawa
//
//  Created by Bram on 25/11/2023.
//

import Foundation
import SwiftUI

struct SubjectDetail: View {
    var subject: Subject
    var body: some View {
        Frame{
            Text("Open assignments")
              .font(
                Font.custom("Inter", size: 20)
                  .weight(.medium)
              )
              .foregroundColor(Color(.primary))
            
            if (subject.openAssignments.isEmpty){
                Card{
                    Text("You have no open assignments at the moment.")
                }
            }else {
                AssignmentList(assignments: subject.openAssignments)
            }

            Text("Closed assignments")
                .font(
                  Font.custom("Inter", size: 20)
                    .weight(.medium)
                )
                .foregroundColor(Color(.primary))
            if (subject.closedAssignments.isEmpty){
                Card{
                    Text("You have no closed assignments at the moment.")
                }
            }else {
                AssignmentList(assignments: subject.closedAssignments)
            }
        }
    }
}

struct AssignmentList: View {
    var assignments: [Assignment]
    var body: some View {
        ForEach(assignments, id: \.id){ assignment in
            NavigationLink {
                AssignmentDetail(assignment: assignment)
            } label: {
                AssignmentListItem(assignment: .presentPerfectAssignment)
            }
        }
    }
}

struct AssignmentListItem: View {
    var assignment: Assignment
    var body: some View {
        Card{
            HStack{
                VStack(alignment: .leading, spacing: 8){
                    Text(assignment.name)
                    Text("Deadline: \(assignment.deadline.formatted(date: .complete, time: .shortened))")
                        .font(.caption)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color("Primary"))
            }
        }
    }
}

#Preview {
    SubjectDetail(subject: .english)
}
