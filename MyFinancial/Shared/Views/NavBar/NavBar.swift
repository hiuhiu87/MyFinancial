//
//  NavBar.swift
//  MyFinancial
//
//  Created by NMH on 20/7/25.
//

import SwiftUI

struct NavBar: View {
    var body: some View {
        HStack(alignment: .center) {
            VStack {
                Text("Xin chào, Minh!")
                    .font(.headline)
                Text("Hôm nay bạn thế nào?")
                    .font(.caption)
            }
            Spacer()
            HStack {
                Image(systemName: "bell")
                    .padding(.horizontal)
                Image(systemName: "gear")
            }
        }
        .padding()
        .foregroundStyle(.white)
    }
}

#Preview {
    NavBar()
        .background(Color.blue)
}
