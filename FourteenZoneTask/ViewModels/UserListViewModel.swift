//
//  UserListViewModel.swift
//  FourteenZoneTask
//
//  Created by Sabal on 6/12/26.
//

import Foundation
import Observation

enum UserListState: Equatable {
    case idle
    case loading
    case loaded
    case empty
    case error(String)
}

@MainActor
@Observable
final class UserListViewModel {
    private(set) var users: [User] = []
    private(set) var state: UserListState = .idle
    var searchText = ""

    private let userService: UserServiceProtocol

    init(userService: UserServiceProtocol) {
        self.userService = userService
    }

    var filteredUsers: [User] {
        guard !searchText.isEmpty else { return users }
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else { return users }

        return users.filter { user in
            user.name.localizedCaseInsensitiveContains(query)
                || user.email.localizedCaseInsensitiveContains(query)
                || user.address.city.localizedCaseInsensitiveContains(query)
        }
    }

    var isRefreshing: Bool {
        state == .loading && !users.isEmpty
    }

    func loadUsers(showLoadingIndicator: Bool = true) async {
        if showLoadingIndicator || users.isEmpty {
            state = .loading
        }

        if users.isEmpty, let cachedUsers = userService.getCachedUsers(), !cachedUsers.isEmpty {
            users = cachedUsers
            state = .loaded
        }

        do {
            let fetchedUsers = try await userService.fetchUsers()
            users = fetchedUsers
            state = fetchedUsers.isEmpty ? .empty : .loaded
        } catch {
            if users.isEmpty {
                state = .error(error.localizedDescription)
            } else {
                state = .loaded
            }
        }
    }

    func refresh() async {
        await loadUsers(showLoadingIndicator: false)
    }
}
