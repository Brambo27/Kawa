//
//  UploadDelegate.swift
//  Kawa
//
//  Created by Bram on 08/01/2024.
//

import Foundation

class UploadDelegate: NSObject, URLSessionTaskDelegate {
    var progressHandler: ((Float) -> Void)?

    func urlSession(_ session: URLSession, task: URLSessionTask, didSendBodyData bytesSent: Int64, totalBytesSent: Int64, totalBytesExpectedToSend: Int64) {
        let progress = Float(totalBytesSent) / Float(totalBytesExpectedToSend)
        progressHandler?(progress)
    }
}
