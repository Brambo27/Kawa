//
//  AssignmentDetail.swift
//  Kawa
//
//  Created by Bram on 25/11/2023.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import Network

struct AssignmentDetail:View {
    var assignment: Assignment
    var monitor = NWPathMonitor()
    @State var openFilePicker: Bool = false
    @State var fileHasBeenPicked: Bool = false
    @State var isConnected: Bool = true
    @State var isExpensive: Bool = false
    @StateObject private var viewModel = UploadViewModel()
    
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
                if(assignment.userFiles.isEmpty || true){
                    if fileHasBeenPicked {
                        if isConnected && !isExpensive
                        {
                            if(viewModel.uploadProgress != 1.0){
                                Text("Connected to wifi, upload is now in progress.")
                                Spacer()
                                progressSteps(wifi: isConnected && !isExpensive, step: 2)
                            }else{
                                Text("Upload complete.")
                                Spacer()
                                progressSteps(wifi: isConnected && !isExpensive, step: 3)
                            }
                            Spacer()
                            ProgressView("Uploading", value: viewModel.uploadProgress, total: 1.0)
                                .progressViewStyle(BiggerProgressStyle())
                        }else {
                            Text("File has been successfully submitted and is queued for upload, waiting for wifi connection to start")
                            Spacer()
                            progressSteps(wifi: isConnected && !isExpensive, step: 1)
                        }
                    } else {
                        Text("You have not submitted any files yet")
                    }
                    
                }else {
                    ForEach(assignment.userFiles, id: \.id){ userFile in
                        Text("\(userFile.fileName)")
                    }
                }
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
                        let gotAccess = file.startAccessingSecurityScopedResource()
                        if !gotAccess {
                            print("No access")
                            return
                        }
                        
                        fileHasBeenPicked = true
                        handlePickedFile(url: file, viewModel: viewModel, assignment: assignment)
                        
                        file.stopAccessingSecurityScopedResource()
                    case .failure(let failure):
                        print("Failure: \(failure)")
                    }
                }
        }.task {
            //            monitor.pathUpdateHandler = { path in
            //                if path.status == .satisfied {
            //                    isConnected = true
            //                    isExpensive = path.isExpensive
            //                } else {
            //                    isConnected = false
            //                }
            //            }
            
            let queue = DispatchQueue(label: "Monitor")
            monitor.start(queue: queue)
        }
    }
}

struct progressSteps: View {
    var wifi: Bool
    var step: Int
    
    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: wifi ? "wifi" : "wifi.slash")
                .foregroundStyle(Color(.primary))
            Spacer()
            Rectangle()
              .foregroundColor(.clear)
              .frame(width: 75, height: 1)
              .background(.black)
            Spacer()

            Image(systemName: "square.and.arrow.up")
                .foregroundStyle(step > 1 ? Color(.primary) : Color(.prettyGrey))

            Spacer()
            Rectangle()
              .foregroundColor(.clear)
              .frame(width: 75, height: 1)
              .background(.black)
            Spacer()
            Image(systemName: "checkmark")
                .foregroundStyle(step > 2 ? Color(.primary) : Color(.prettyGrey))

        }
        .padding(0)
        .frame(maxWidth: .infinity, alignment: .center)
    }
}

private func handlePickedFile(url: URL, viewModel: UploadViewModel, assignment: Assignment) -> Void {
    let userId = "wodhawohdahdwa" //TODO: Remove
    do{
        //TODO: this needs to move somewhere else
        let content = try Data.init(contentsOf: url, options: .mappedIfSafe)
        let documentsUrl =  FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        guard let uploadUrl = URL(string: "\(URLs.uploadUrl)") else {
            print("something went wrong")
            return
        }
        
        viewModel.uploadData(fileUrl: url, uploadUrl: uploadUrl, userId: userId, assignmentId: assignment.id ?? "-0")
        
        //Upload from destinationUrl, delete file after upload
        //                        print(destinationUrl.upload(to: uploadUrl))
        //                        try content.write(to: destinationUrl)
        
    }
    catch{
        print(error)
    }
}

struct BiggerProgressStyle: ProgressViewStyle {
    func makeBody(configuration: Configuration) -> some View {
        let fractionCompleted = configuration.fractionCompleted ?? 0
        
        return ZStack(alignment: .leading) {
            RoundedRectangle(cornerRadius: 10)
                .frame(height: 12) // Adjust the height as needed
                .foregroundColor(Color(.lightGray))
            
            RoundedRectangle(cornerRadius: 10)
                .trim(from: 0, to: fractionCompleted)
                .foregroundColor(Color(.primary))
        }
    }
}


#Preview {
    AssignmentDetail(assignment: .presentPerfectAssignment)
}
