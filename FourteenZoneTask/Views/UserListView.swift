//
//  UserListView.swift
//  FourteenZoneTask
//
//  Created by Sabal on 6/12/26.
//

import SwiftUI

struct UserListView: View {
    @State private var viewModel: UserListViewModel

    init(viewModel: UserListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        NavigationStack {
            Group {
                if shouldShowLoading {
                    LoadingView()
                } else if case .error(let message) = viewModel.state, viewModel.users.isEmpty {
                    ErrorStateView(message: message) {
                        Task { await viewModel.loadUsers() }
                    }
                } else if viewModel.state == .empty {
                    EmptyStateView()
                } else {
                    userList
                }
            }
            .navigationTitle("Users")
//            .navigationBarTitleDisplayMode(.inline)
            .searchable(text: $viewModel.searchText, prompt: "Search by name, email, or city")
            .task {
                if viewModel.state == .idle {
                    await viewModel.loadUsers()
                }
            }
        }
    }

    private var shouldShowLoading: Bool {
        viewModel.users.isEmpty && (viewModel.state == .idle || viewModel.state == .loading)
    }

    private var userList: some View {
        List {
            if viewModel.filteredUsers.isEmpty {
                EmptyStateView(
                    title: "No Results",
                    message: "No users match \"\(viewModel.searchText)\".",
                    systemImage: "magnifyingglass"
                )
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            } else {
                ForEach(viewModel.filteredUsers) { user in
                    NavigationLink(value: user) {
                        UserRowView(user: user)
                    }
                }
            }
        }
        .listStyle(.insetGrouped)
        .refreshable {
            await viewModel.refresh()
        }
        .overlay {
            if viewModel.isRefreshing {
                ProgressView()
                    .padding(12)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 10))
            }
        }
        .navigationDestination(for: User.self) { user in
            UserDetailView(user: user)
        }
    }
}

#if DEBUG
#Preview("Loaded") {
    UserListView(viewModel: UserListViewModel(userService: MockUserService.preview))
}

#Preview("Error") {
    UserListView(viewModel: UserListViewModel(
        userService: MockUserService(shouldFail: true, delayNanoseconds: 0)
    ))
}
#endif
