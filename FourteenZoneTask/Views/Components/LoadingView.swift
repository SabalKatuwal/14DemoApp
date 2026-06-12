//
//  LoadingView.swift
//  FourteenZoneTask
//
//  Created by Sabal on 6/12/26.
//

import SwiftUI

struct LoadingView: View {
    var message: String = "Loading users..."

    var body: some View {
        VStack(spacing: 16) {
            ProgressView()
                .controlSize(.large)
            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    LoadingView()
}
