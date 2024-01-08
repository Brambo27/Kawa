//
//  Frame.swift
//  Kawa
//
//  Created by Bram on 23/11/2023.
//

import Foundation
import SwiftUI

struct Frame<Content:View>: View {
    let alignment: HorizontalAlignment
    let content: () -> Content

    init(alignment: HorizontalAlignment = .center, @ViewBuilder content: @escaping () -> Content){
        self.content = content
        self.alignment = alignment
    }
    
    var body: some View {
        ScrollView(.vertical){
            VStack(alignment: alignment, spacing: 12) {
                content()
            }
            .padding(12)
        }.background(Color("Background"))
    }
}
