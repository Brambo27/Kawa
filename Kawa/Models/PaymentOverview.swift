//
//  PaymentProgress.swift
//  Kawa
//
//  Created by Bram on 27/11/2023.
//

import Foundation
import SwiftData

struct PaymentOverview {
    var payments: [Payment]
    var progress: PaymentProgress
    
    init(payments: [Payment], progress: PaymentProgress) async throws {
        self.payments = payments
        self.progress = progress
    }
}

struct PaymentProgress: Codable{
    let fee: Int
    let paid: Int
    
    init(from: PaymentProgressEntity) {
        self.fee = from.fee
        self.paid = from.paid
    }
}

struct PaymentProgressEntity: Codable{
    let fee: Int
    let paid: Int
}

extension PaymentOverview {
    @MainActor
    static func fetchPaymentProgress() async throws -> PaymentProgress{
        guard let url = URL(string: "https://virtserver.swaggerhub.com/A6K1M3TY/PaymentService/1.0.0/payments/overview") else {
            print("something went wrong")
            throw DownloadError.invalidUrl//TODO: Figure this out
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try JSONDecoder().decode(PaymentProgressEntity.self, from: data)
        let progress = PaymentProgress(from: result)
        return PaymentProgress(from: PaymentProgressEntity(fee: 1500000, paid: 1000000))
    }
}

extension PaymentOverview {
    @MainActor
    static func fetchPayments(modelContext: ModelContext) async throws {
        guard let url = URL(string: "https://virtserver.swaggerhub.com/A6K1M3TY/PaymentService/1.0.0/payments") else {
            print("something went wrong")
            throw DownloadError.invalidUrl //TODO: Figure this out
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let result = try JSONDecoder().decode([PaymentEntity].self, from: data)
        
        for payment in result {
            try await modelContext.insert(Payment(from: payment))
        }
    }
}
