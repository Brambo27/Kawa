//
//  AssignmentDetail.swift
//  Kawa
//
//  Created by Bram on 25/11/2023.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct AssignmentDetail:View {
    var assignment: Assignment
    var handlePickedFile: (URL) -> Void
    @State var openFilePicker: Bool = false
    
    var body: some View {
        Frame(alignment: .leading){
            Card{
                Text(assignment.name).font(.title2)
                Text(assignment.assignmentDescription).font(.body)
                Text("Deadline: \(assignment.deadline.formatted(date: .complete, time: .shortened))")
                    .font(.caption)
            }
            
            Text("Files")
                .foregroundStyle(Color("Primary"))
            
            Card{
                ForEach(assignment.userFiles, id: \.id){ userFile in
                    Text(userFile.assignmentFile)
                }
                
                //Get Files
                //If no Files, display empty message
                //Else display files
            }
            
            Button("Choose file", systemImage: "plus"){
                openFilePicker = true
            }.buttonStyle(.bordered)
                .fileImporter(isPresented: $openFilePicker, allowedContentTypes: [.text, .pdf, .rtf,
                                                                                  .plainText, .utf8PlainText, .utf16PlainText,
                                                                                  .rtfd, .flatRTFD, UTType("com.microsoft.word.doc")!,
                                                                                  UTType("org.openxmlformats.wordprocessingml.document")!]
                              
                ) { result in
                    switch result {
                    case .success(let file):
                        print("success")
                        let gotAccess = file.startAccessingSecurityScopedResource()
                        if !gotAccess {
                            print("No access")
                            return
                        }
                        
                        handlePickedFile(file)
                        
                        file.stopAccessingSecurityScopedResource()
                    case .failure(let failure):
                        print("Failure: \(failure)")
                    }
                }
        }
    }
}

#Preview {
    AssignmentDetail(assignment: .presentPerfectAssignment) { url in
        print(url)
    }
}
