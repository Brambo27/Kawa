//
//  DownloadError.swift
//  Kawa
//
//  Created by Bram on 27/11/2023.
//

import Foundation

enum DownloadError: Error {
    case wrongDataFormat(error: Error)
    case missingData
    case invalidUrl
}
