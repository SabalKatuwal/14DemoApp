//
//  UserRowView.swift
//  FourteenZoneTask
//
//  Created by Sabal on 6/12/26.
//

import SwiftUI

struct UserRowView: View {
    let user: User

    var body: some View {
        HStack(spacing: 14) {
            AvatarView(name: user.name)

            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.headline)
                    .foregroundStyle(.primary)

                Label(user.email, systemImage: "envelope")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                Label(user.address.city, systemImage: "mappin.and.ellipse")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)
            }

            Spacer(minLength: 0)

//            Image(systemName: "chevron.right")
//                .font(.caption.weight(.semibold))
//                .foregroundStyle(.tertiary)
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(user.name), \(user.email), \(user.address.city)")
    }
}

private struct AvatarView: View {
    let name: String

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.accentColor.opacity(0.15))
                .frame(width: 44, height: 44)

            Text(initials)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.accentColor)
        }
        .accessibilityHidden(true)
    }

    private var initials: String {
        let components = name.split(separator: " ")
        let letters = components.prefix(2).compactMap { $0.first }
        return String(letters).uppercased()
    }
}

#if DEBUG
#Preview {
    List {
        UserRowView(user: .preview)
    }
}
#endif
