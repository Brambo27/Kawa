//
//  Card.swift
//  Kawa
//
//  Created by Bram on 23/11/2023.
//

import Foundation
import SwiftUI

enum CardLayout {
    case horizontal
    case vertical
}

struct Card<Content:View>: View {
    let content: () -> Content
    let layout: CardLayout
    let cardColor: Color
    let isSquare: Bool
    
    init(layout: CardLayout = .vertical, cardColor: Color = .white, isSquare: Bool = false, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.cardColor = cardColor
        self.isSquare = isSquare
        self.layout = layout
    }
    
    var body: some View {
        if(isSquare){
            GeometryReader { geometry in
                switch layout {
                case .horizontal:
                    HStack(alignment: .top, spacing: 6) {
                         content()
                     }
                     .padding(12)
                     .frame(width: geometry.size.width, height: isSquare ? geometry.size.width : nil)
                     .background(cardColor)
                     .cornerRadius(8)
                case .vertical:
                    VStack(alignment: .leading, spacing: 6) {
                         content()
                     }
                     .padding(12)
                     .frame(width: geometry.size.width, height: isSquare ? geometry.size.width : nil)
                     .background(cardColor)
                     .cornerRadius(8)
                }

             }.aspectRatio(contentMode: .fit)
        }
        else{
            switch layout {
            case .horizontal:
                HStack(alignment: .top, spacing: 6) {
                    content()
                }
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(cardColor)
                .cornerRadius(8)
            case .vertical:
                VStack(alignment: .leading, spacing: 6) {
                    content()
                }
                .padding(12)
                .frame(maxWidth: .infinity)
                .background(cardColor)
                .cornerRadius(8)
            }

        }
    }
}

#Preview {
    Frame{
        Card(content: {
            VStack(alignment: .center, spacing: 0) {
                Text("Deadlines")
                    .font(.title2)
                  .foregroundColor(Color("Primary"))
            }
            .padding(0)
            .frame(maxWidth: .infinity, alignment: .top)
            
            Text("You have no upcoming deadlines")
                .font(.body)
              .multilineTextAlignment(.center)
              .frame(maxWidth: .infinity, alignment: .top)
        })
        
        Card(layout: .horizontal, content: {
            Text("Total paid")
            Spacer()
            Text("TSh 1.171.196")
        })
    }
}
