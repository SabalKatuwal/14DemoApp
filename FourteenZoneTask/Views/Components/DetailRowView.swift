//
//  DetailRowView.swift
//  FourteenZoneTask
//
//  Created by Sabal on 6/12/26.
//

import SwiftUI

struct DetailRowView: View {
    let title: String
    let value: String
    let systemImage: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: systemImage)
                .font(.body)
                .foregroundStyle(Color.accentColor)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)

                Text(value)
                    .font(.body)
                    .foregroundStyle(.primary)
                    .textSelection(.enabled)
            }

            Spacer(minLength: 0)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    DetailRowView(
        title: "Email",
        value: "Sincere@april.biz",
        systemImage: "envelope"
    )
    .padding()
}
