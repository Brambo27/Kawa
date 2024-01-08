//
//  Payment.swift
//  Kawa
//
//  Created by Bram on 27/11/2023.
//

import Foundation
import SwiftData

//Example JSON:
//{
//  "paymentId": "550e8400-e29b-41d4-a716-446655440000",
//  "userId": "ff42bf7e-ded2-4982-91a3-6b5570ec8b93",
//  "courseId": "68673a70-87fe-432e-a2e3-4179d3c34c57",
//  "userName": "John Doe",
//  "amountPaid": 50,
//  "cashier": "Sam Smith",
//  "addedAt": "2023-11-21T12:34:56Z",
//  "description": "Inital payment",
//  "paymentType": "Credit Card",
//  "activityId": null
//}

@Model
class Payment {
    @Attribute(.unique) var id: UUID
    var userId: UUID
    var courseId: UUID
    var userName: String
    var amountPaid: Double
    var cashier: String
    var addedAt: Date
    var paymentDescription: String
    var paymentType: String
    var activityId: UUID?
    
    init(from: PaymentEntity) async throws {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        self.id = from.paymentId
        self.userId = from.userId
        self.courseId = from.courseId
        self.userName = from.userName
        self.amountPaid = from.amountPaid
        self.cashier = from.cashier
        self.addedAt = dateFormatter.date(from: from.addedAt) ?? Date() //TODO: handle error instead of using date of today
        self.paymentDescription = from.description
        self.paymentType = from.paymentType
        self.activityId = from.activityId
    }
}

struct PaymentEntity: Codable {
    var paymentId: UUID
    var userId: UUID
    var courseId: UUID
    var userName: String
    var amountPaid: Double
    var cashier: String
    var addedAt: String
    var description: String
    var paymentType: String
    var activityId: UUID?
}


