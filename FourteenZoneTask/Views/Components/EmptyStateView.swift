//
//  EmptyStateView.swift
//  FourteenZoneTask
//
//  Created by Sabal on 6/12/26.
//

import SwiftUI

struct EmptyStateView: View {
    var title: String = "No Users Found"
    var message: String = "There are no users to display."
    var systemImage: String = "person.3"

    var body: some View {
        ContentUnavailableView(title, systemImage: systemImage, description: Text(message))
    }
}

#Preview {
    EmptyStateView()
}
