//
//  UploadViewModel.swift
//  Kawa
//
//  Created by Bram on 08/01/2024.
//

import Foundation
import SwiftUI

class UploadViewModel: ObservableObject {
    @Published var uploadProgress: Float = 0.0

    func uploadData(fileUrl: URL, uploadUrl: URL, userId: String, assignmentId: String) {
        let userId = "aouwhdioauhwd"
        let assignmentId = "ouawhdiuahwdiawh"
        
        // Create an instance of UploadDelegate
        let uploadDelegate = UploadDelegate()

        // Create a URLSession with the delegate
        let session = URLSession(configuration: .default, delegate: uploadDelegate, delegateQueue: nil)

        // Create a URLRequest with the URL and the HTTP method
        var request = URLRequest(url: uploadUrl)
        request.httpMethod = "POST"

        // Create a boundary for the multipart/form-data
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        var file = Data()
        do{
            file = try Data.init(contentsOf: fileUrl, options: .mappedIfSafe)
        } catch{
            print("error uploading file: \(String(describing: error))")
        }
        
        // Add UserId parameter to the body
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"UserId\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(userId)\r\n".data(using: .utf8)!)

        // Add AssignmentId parameter to the body
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"AssignmentId\"\r\n\r\n".data(using: .utf8)!)
        body.append("\(assignmentId)\r\n".data(using: .utf8)!)

        // Add file data to the body
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"example.txt\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: application/octet-stream\r\n\r\n".data(using: .utf8)!)
        body.append(file)
        body.append("\r\n".data(using: .utf8)!)

        // Add closing boundary
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)

        // Create an upload task
        let uploadTask = session.uploadTask(with: request, from: body) { (data, response, error) in
            print(response)
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                    print("json response: \(json)")
                }
            }else{
                print("error uploading file: \(String(describing: error))")
            }
        }
        print(uploadTask)

        // Start observing the progress
        uploadDelegate.progressHandler = { progress in
            DispatchQueue.main.async {
                self.uploadProgress = progress
            }
        }

        // Resume the task to start the upload
        uploadTask.resume()
    }
}
