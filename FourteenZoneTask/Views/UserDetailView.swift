//
//  UserDetailView.swift
//  FourteenZoneTask
//
//  Created by Sabal on 6/12/26.
//

import SwiftUI

struct UserDetailView: View {
    let user: User

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                detailsSection
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("User Details")
        .navigationBarTitleDisplayMode(.inline)
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.accentColor.opacity(0.15))
                    .frame(width: 80, height: 80)

                Text(initials(for: user.name))
                    .font(.title.weight(.semibold))
                    .foregroundStyle(Color.accentColor)
            }

            Text(user.name)
                .font(.title2.weight(.semibold))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
    }

    private var detailsSection: some View {
        VStack(spacing: 0) {
            DetailRowView(title: "Full Name", value: user.name, systemImage: "person")
            Divider().padding(.leading, 36)
            DetailRowView(title: "Email", value: user.email, systemImage: "envelope")
            Divider().padding(.leading, 36)
            DetailRowView(title: "Phone", value: user.phone, systemImage: "phone")
            Divider().padding(.leading, 36)
            DetailRowView(title: "Company", value: user.company.name, systemImage: "building.2")
            Divider().padding(.leading, 36)
            DetailRowView(title: "Website", value: formattedWebsite, systemImage: "globe")
        }
        .padding()
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 12))
    }

    private var formattedWebsite: String {
        user.website.hasPrefix("http") ? user.website : "https://\(user.website)"
    }

    private func initials(for name: String) -> String {
        let components = name.split(separator: " ")
        let letters = components.prefix(2).compactMap { $0.first }
        return String(letters).uppercased()
    }
}

#if DEBUG
#Preview {
    NavigationStack {
        UserDetailView(user: .preview)
    }
}
#endif
