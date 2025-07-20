//
//  ContentView.swift
//  MyFinancial
//
//  Created by NMH on 20/7/25.
//

import SwiftUI

struct ContentView: View {

    let topBackgroundColor = LinearGradient(
        gradient: Gradient(colors: [
            Color(hex: "2563eb"),
            Color(hex: "9333ea"),
        ]),
        startPoint: .leading,
        endPoint: .trailing
    )

    @State private var selectedFlavor: FinanceType = .transaction

    var body: some View {
        VStack {
            VStack {
                NavBar()
                BalanceCard()
            }
            .padding()
            .frame(
                maxWidth: .infinity,
                maxHeight: 330
            )
            .background(
                RoundedRectangle(cornerRadius: 16)
                    .fill(topBackgroundColor)
            )
            FunctionListView()
                .padding(.horizontal, 24)
                .offset(y: -25)
            Picker("FinanceType", selection: $selectedFlavor) {
                Text("Giao dịch").tag(FinanceType.transaction)
                Text("Ngân sách").tag(FinanceType.budget)
                Text("Tiết kiệm").tag(FinanceType.saving)
            }
            .pickerStyle(.segmented)
            .padding()

            switch selectedFlavor {
            case .budget:
                BudgetView()
            case .saving:
                SavingView()
            case .transaction:
                TransactionView()
            }

            Spacer()
        }
        .frame(
            minWidth: 0,
            maxWidth: .infinity,
            minHeight: 0,
            maxHeight: .infinity
        )
        .ignoresSafeArea(.all)
    }
}

#Preview {
    ContentView()
}
