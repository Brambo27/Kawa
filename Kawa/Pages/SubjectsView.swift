//
//  SubjectsView.swift
//  Kawa
//
//  Created by Bram on 22/11/2023.
//

import Foundation
import SwiftUI
import SwiftData

struct SubjectsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Module.id) var modules: [Module]
    
    var body: some View {
        Frame{
            LazyVStack{
                ForEach(modules){ module in
                    ModuleView(module: module)
                }
            }
        }.task {
            do {
                if modules.isEmpty{
                    Module.insertSampleData(modelContext: modelContext)
                }
            }
            catch {
                print(error)
            }
        }
        .toolbar {
            Button {
                Module.reloadSampleData(modelContext: modelContext)
            } label: {
                Label("", systemImage: "arrow.clockwise")
                    .help("Reload sample data")
            }
        }
    }
}

struct ModuleView: View {
    @State var isCollapsed: Bool = false
    
    var module: Module
    var body: some View {
        ModuleHeader(module: module, isCollapsed: $isCollapsed)
        if !isCollapsed {
            SubjectList(subjects: module.subjects)
        }
    }
}

struct ModuleHeader: View {
    var module: Module
    @Binding var isCollapsed: Bool
    
    var body: some View {
        Card{
            HStack{
                Text("Module \(module.id): \(module.moduleName)")
                    .foregroundStyle(Color("Primary"))
                Spacer()
                Image(systemName: isCollapsed ? "chevron.left" : "chevron.down")
            }
        }.onTapGesture {
            isCollapsed = !isCollapsed
        }
    }
}

struct SubjectList: View{
    var subjects: [Subject]
    
    var body: some View {
        LazyVStack(content: {
            ForEach(subjects, id: \.courseId){ subject in
                NavigationLink(destination: {
                    SubjectDetail(subject: subject)
                }, label: {
                    SubjectListItem(subject: subject)
                })
            }
        })
    }
}

struct SubjectListItem: View {
    var subject: Subject
    var body: some View {
        Card{
            HStack{
                Text(subject.courseName)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundStyle(Color("Primary"))
            }
        }
    }
}

#Preview {
    SubjectsView()
        .modelContainer(for: Module.self, inMemory: true)
}
