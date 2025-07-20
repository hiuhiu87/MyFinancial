//
//  TransactionView.swift
//  MyFinancial
//
//  Created by NMH on 20/7/25.
//

import SwiftUI

struct TransactionView: View {
    var body: some View {
        VStack {
            HStack {
                Text("Giao dịch gần đây")
                    .fontWeight(.bold)
                    .font(.headline)
                Spacer()
                Button(action: {
                    print("Xem tất cả")
                }) {
                    Text("Xem tất cả")
                        .foregroundStyle(.black)
                }
            }
            .padding()
            ScrollView {
                VStack(spacing: 14) {
                    TransactionItem(
                        transactionLevel: .mediumExpense,
                        transactionName: "Cơm trưa",
                        transactionDate: "12:30",
                        transactionAmount: "150.000 đ"
                    )
                    TransactionItem(
                        transactionLevel: .mediumExpense,
                        transactionName: "Cơm trưa",
                        transactionDate: "12:30",
                        transactionAmount: "150.000 đ"
                    )
                    TransactionItem(
                        transactionLevel: .mediumExpense,
                        transactionName: "Cơm trưa",
                        transactionDate: "12:30",
                        transactionAmount: "150.000 đ"
                    )
                    TransactionItem(
                        transactionLevel: .mediumExpense,
                        transactionName: "Cơm trưa",
                        transactionDate: "12:30",
                        transactionAmount: "150.000 đ"
                    )
                    TransactionItem(
                        transactionLevel: .mediumExpense,
                        transactionName: "Cơm trưa",
                        transactionDate: "12:30",
                        transactionAmount: "150.000 đ"
                    )
                    TransactionItem(
                        transactionLevel: .mediumExpense,
                        transactionName: "Cơm trưa",
                        transactionDate: "12:30",
                        transactionAmount: "150.000 đ"
                    )
                    TransactionItem(
                        transactionLevel: .mediumExpense,
                        transactionName: "Cơm trưa",
                        transactionDate: "12:30",
                        transactionAmount: "150.000 đ"
                    )
                }
                .padding()
            }
        }
    }
}

#Preview {
    TransactionView()
}
