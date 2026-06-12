//
//  ErrorStateView.swift
//  FourteenZoneTask
//
//  Created by Sabal on 6/12/26.
//

import SwiftUI

struct ErrorStateView: View {
    let message: String
    let retryAction: () -> Void

    var body: some View {
        ContentUnavailableView {
            Label("Something Went Wrong", systemImage: "exclamationmark.triangle")
        } description: {
            Text(message)
        } actions: {
            Button("Try Again", action: retryAction)
                .buttonStyle(.borderedProminent)
        }
    }
}

#Preview {
    ErrorStateView(message: "Unable to connect to the server.") {}
}
