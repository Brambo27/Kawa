//
//  PaymnetView.swift
//  Kawa
//
//  Created by Bram on 27/11/2023.
//

import Foundation
import SwiftUI
import SwiftData

struct PaymentView: View {
    @Environment(\.modelContext) private var modelContext
    @State var progress: PaymentProgress?

    var body: some View {
        Frame(alignment: .leading){
            PaymentProgressView(progress: $progress)

            Text("Payments")
                .foregroundStyle(Color("Primary"))
            
            PaymentsOverview(progress: $progress)
            
            Text("Payment history")
                .foregroundStyle(Color("Primary"))
            
            PaymentHistory()
        }
        .task {
            do {
                try await PaymentOverview.fetchPayments(modelContext: modelContext)
                progress = try await PaymentOverview.fetchPaymentProgress()
            }
            catch {
                print(error)
            }
        }
    }
}

struct PaymentProgressView: View {
    @Binding var progress: PaymentProgress?
    
    var body: some View {
        Card{
            if let progress{
                ZStack{
                    Circle()
                        .stroke(lineWidth: 10.0)
                        .opacity(0.3)
                        .foregroundColor(Color(.systemGray5))
                    
                    Circle()
                        .trim(from: 0.0, to: CGFloat(progress.paid)/CGFloat(progress.fee))
                        .stroke(style: StrokeStyle(lineWidth: 10.0, lineCap: .round, lineJoin: .round))
                        .foregroundColor(Color("Primary"))
                        .rotationEffect(Angle(degrees: 270.0))
                    
                    Text("\(progress.paid) / \(progress.fee) TSh")
                }.frame(width: 180, height: 180)
            }
        }
    }
}
                                       

struct PaymentsOverview: View {
    @Binding var progress: PaymentProgress?

    var body: some View {
        if let progress = progress {
            Card(layout: .horizontal, cardColor: Color(.green)){
                Text("Total paid")
                Spacer()
                Text("TSh \(progress.paid)")
            }
            Card(layout: .horizontal, cardColor: Color(.red)){
                Text("Total tuition")
                Spacer()
                Text("TSh \(progress.fee)")
            }
            Card(layout: .horizontal){
                Text("Total left to pay")
                Spacer()
                Text("TSh \(progress.fee - progress.paid)")
            }
        }
    }
}

struct PaymentHistory: View {
    @Query private var payments: [Payment]

    var body: some View {
        ForEach(payments, id: \.id){ payment in
            Card(layout: .horizontal){
                Text(payment.paymentDescription)
//                    Text(payment.paymentType)
//                    Text(payment.cashier)
//                    Text(payment.addedAt, style: .date)
                
                Spacer()

                Text("TSh \(payment.amountPaid, specifier: "%.2f")")
            }
        }
    }
}

#Preview {
    PaymentView()
        .modelContainer(for: [Payment.self])
}
