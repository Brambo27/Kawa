//
//  URL+Upload.swift
//  Kawa
//
//  Created by Bram on 25/11/2023.
//

import Foundation

extension URL{
    func upload(to: URL){
        let boundary = UUID().uuidString
        let session = URLSession.shared
        var urlRequest = URLRequest(url: to)
        urlRequest.httpMethod = "POST"
        
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var data = Data()
        do{
            var file = try Data.init(contentsOf: self, options: .mappedIfSafe)


        // Add the image data to the raw http request data
        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(self.lastPathComponent)\"\r\n".data(using: .utf8)!)
        data.append("Content-Type: image/png\r\n\r\n".data(using: .utf8)!)
        data.append(file)
        data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
            
        session.uploadTask(with: urlRequest, from: data, completionHandler: { responseData, response, error in
            print(responseData)
            print(response)
            if error == nil {
                let jsonData = try? JSONSerialization.jsonObject(with: responseData!, options: .allowFragments)
                if let json = jsonData as? [String: Any] {
                    print("json response: \(json)")
                }
            }else{
                print("error uploading file: \(error)")
            }
        }).resume()
        }catch{
            print("Error")
        }
    }
}
