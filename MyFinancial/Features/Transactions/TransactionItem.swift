//
//  TransactionItem.swift
//  MyFinancial
//
//  Created by NMH on 20/7/25.
//

import SwiftUI

enum TransactionLevel: String {
    case income = "income"
    case lowExpense = "low_expense"
    case highExpense = "high_expense"
    case mediumExpense = "medium_expense"

    var color: Color {
        switch self {
        case .income:
            return Color(hex: "#17A34A")
        case .lowExpense:
            return Color(hex: "#2463EB")
        case .highExpense:
            return Color(hex: "#9334E9")
        case .mediumExpense:
            return Color(hex: "#DC2625")
        }
    }
}

struct TransactionItem: View {

    let transactionLevel: TransactionLevel

    let transactionName: String

    let transactionDate: String

    let transactionAmount: String

    var body: some View {
        HStack {
            Image(systemName: "dollarsign.circle")
                .resizable()
                .frame(
                    width: 28,
                    height: 28
                )
                .padding()
                .foregroundColor(transactionLevel.color)
            VStack(alignment: .leading) {
                Text(transactionName)
                    .font(.system(size: 16))
                Text(transactionDate)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Text(
                "\(transactionLevel == .income ? "+" : "-") \(transactionAmount)"
            )
            .font(.title2)
            .fontWeight(.bold)
            .foregroundStyle(
                transactionLevel != .income
                    ? .red : .green
            )
            .padding()
        }
        .frame(
            maxWidth: 350,
            maxHeight: 66
        )
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(.white)
                .shadow(radius: 2)
        )
    }
}

#Preview {
    TransactionItem(
        transactionLevel: .mediumExpense,
        transactionName: "Cơm trưa",
        transactionDate: "12:30",
        transactionAmount: "150.000 đ"
    )
}
