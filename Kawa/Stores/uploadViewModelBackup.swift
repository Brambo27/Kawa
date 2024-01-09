//
//  UploadViewModel.swift
//  Kawa
//
//  Created by Bram on 08/01/2024.
//

import Foundation
import SwiftUI

class UploadViewModel2: ObservableObject {
    @Published var uploadProgress: Float = 0.0

    func uploadData(fileUrl: URL, uploadUrl: URL) {
        // Create an instance of UploadDelegate
        let uploadDelegate = UploadDelegate()

        // Create a URLSession with the delegate
        let session = URLSession(configuration: .default, delegate: uploadDelegate, delegateQueue: nil)
        
        var data = Data()

        let boundary = "Boundary-\(UUID().uuidString)"
        let postData = formatPostData(userId: "test", assignmentId: "test", fileUrl: fileUrl)

        var request = URLRequest(url: URL(string: URLs.uploadUrl)!,timeoutInterval: Double.infinity)
        request.addValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        request.httpMethod = "POST"
        request.httpBody = postData

        // Create an upload task
        let uploadTask = session.uploadTask(with: request, from: postData) { (data, response, error) in
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
    
    func formatPostData(userId: String, assignmentId: String, fileUrl: URL) -> Data? {
        let parameters = [
          [
            "key": "UserId",
            "value": userId,
            "type": "text"
          ],
          [
            "key": "AssignmentId",
            "value": assignmentId,
            "type": "text"
          ],
          [
            "key": "file",
            "src": fileUrl,
            "type": "file"
          ]] as [[String: Any]]

        let boundary = "Boundary-\(UUID().uuidString)"
        var body = ""
        var error: Error? = nil
        for param in parameters {
          if param["disabled"] != nil { continue }
          let paramName = param["key"]!
          body += "--\(boundary)\r\n"
          body += "Content-Disposition:form-data; name=\"\(paramName)\""
          if param["contentType"] != nil {
            body += "\r\nContent-Type: \(param["contentType"] as! String)"
          }
          let paramType = param["type"] as! String
          if paramType == "text" {
            let paramValue = param["value"] as! String
            body += "\r\n\r\n\(paramValue)\r\n"
          } else {
            let paramSrc = param["src"]
              do{
                  var fileData = try Data.init(contentsOf: fileUrl, options: .mappedIfSafe)
                  let fileContent = String(data: fileData, encoding: .utf8)
                  body += "; filename=\"\(paramSrc)\"\r\n"
                    + "Content-Type: \"content-type header\"\r\n\r\n\(fileContent)\r\n"
              }catch{
                  print("I dont know")
              }
          }
        }
        body += "--\(boundary)--\r\n";
        return body.data(using: .utf8)
    }
}
