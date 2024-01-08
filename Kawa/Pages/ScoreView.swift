//
//  ScoreView.swift
//  Kawa
//
//  Created by Bram on 28/11/2023.
//

import Foundation
import SwiftUI
import SwiftData

struct ScoreView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Score.createdAt, order: .reverse) var scores: [Score]
    
    var body: some View {
        Frame{
            ForEach(scores, id: \.id){ score in
                ScoreListItem(score: score)
            }
        }.task {
            modelContext.insert(Score.test)
            modelContext.insert(Score.test2)
        }
    }
}

struct ScoreListItem: View{
    var score: Score
    
    var body: some View {
        Card(layout: .horizontal){
            HStack(alignment: .center, spacing: 25) {
                ZStack{
                    Circle()
                        .frame(width:44, height: 44)
                        .foregroundStyle(Color("Secondary"))
                    Text("\(score.score)")
                        .font(.body)
                        .fontWeight(.medium)
                        .foregroundStyle(Color(score.isPass ? .black : .red))
                }
                
                VStack(alignment: .leading){
                    Text(score.subject?.courseName ?? "")
                        .font(.headline)
                    Text(score.assignment?.name ?? "")
                }
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}

#Preview {
    ScoreView()
        .modelContainer(for: [Score.self], inMemory: true)
}
