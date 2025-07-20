//
//  BalanceCard.swift
//  MyFinancial
//
//  Created by NMH on 20/7/25.
//

import SwiftUI

struct BalanceCard: View {
    var body: some View {
        VStack {
            HStack {
                Text("Tổng số dư")
                Spacer()
                Image(systemName: "eye")
            }
            .foregroundStyle(.white)
            Spacer()
            HStack {
                Text("25.750.000 ₫")
                    .font(.title)
                Spacer()
            }
            .foregroundStyle(.white)
            Spacer()
            HStack(spacing: 90) {
                // Income
                HStack {
                    Image(systemName: "arrow.up.forward")
                        .foregroundStyle(.green)
                    VStack(alignment: .leading) {
                        Text("Thu nhập:")
                            .font(.caption)
                        Text("20.000.000 ₫")
                            .font(.caption)
                    }
                    .foregroundStyle(.white)
                }
                HStack {
                    Image(systemName: "arrow.down.backward")
                        .foregroundStyle(.orange)
                    VStack(alignment: .leading) {
                        Text("Chi tiêu:")
                            .font(.caption)
                        Text("20.000.000 ₫")
                            .font(.caption)
                    }
                    .foregroundStyle(.white)
                }
            }
        }
        .frame(
            maxWidth: 350,
            maxHeight: 120,
        )
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.2))
        )
    }
}

#Preview {
    BalanceCard()
}
