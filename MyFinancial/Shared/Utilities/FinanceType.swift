//
//  FinanceType.swift
//  MyFinancial
//
//  Created by NMH on 20/7/25.
//

enum FinanceType: String, CaseIterable, Identifiable {
    case transaction, budget, saving
    var id: Self { self }
}
