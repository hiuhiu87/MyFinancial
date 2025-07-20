//
//  FunctionListView.swift
//  MyFinancial
//
//  Created by NMH on 20/7/25.
//

import SwiftUI

struct FunctionListView: View {
    @State private var selectedIndex: Int? = nil
    @State private var showingAlert = false
    @State private var alertMessage = ""

    var body: some View {
        HStack(spacing: 20) {
            FunctionButton(
                props: FunctionButtonProps(
                    icon: Image(systemName: "plus")
                        .foregroundStyle(.green),
                    title: "Thêm",
                    action: {
                        handleButtonTap(index: 0, title: "Thêm")
                    }
                )
            )

            FunctionButton(
                icon: Image(systemName: "wallet.bifold")
                    .foregroundStyle(Color(hex: "2463EB")),
                title: "Ví",
                action: {
                    handleButtonTap(index: 1, title: "Ví")
                }
            )

            FunctionButton(
                icon: Image(systemName: "chart.bar")
                    .foregroundStyle(Color(hex: "9334E9")),
                title: "Báo cáo",
                action: {
                    handleButtonTap(index: 2, title: "Báo cáo")
                }
            )

            FunctionButton(
                icon: Image(systemName: "target")
                    .foregroundStyle(Color(hex: "EA580B")),
                title: "Mục tiêu",
                action: {
                    handleButtonTap(index: 3, title: "Mục tiêu")
                }
            )
        }
        .padding(.horizontal, 20)
        .alert("Button Tapped", isPresented: $showingAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }

    private func handleButtonTap(index: Int, title: String) {
        selectedIndex = index
        alertMessage = "Bạn đã nhấn vào: \(title)"
        showingAlert = true

        // Add any specific navigation or action logic here
        switch index {
        case 0:  // Thêm
            print("Navigate to Add Transaction")
        case 1:  // Ví
            print("Navigate to Wallet")
        case 2:  // Báo cáo
            print("Navigate to Reports")
        case 3:  // Mục tiêu
            print("Navigate to Goals")
        default:
            break
        }
    }
}

#Preview {
    FunctionListView()
}
