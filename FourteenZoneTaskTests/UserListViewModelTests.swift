//
//  UserListViewModelTests.swift
//  FourteenZoneTaskTests
//
//  Created by Sabal on 6/12/26.
//

import Foundation
import Testing
@testable import FourteenZoneTask

@MainActor
struct UserListViewModelTests {
    @Test
    func loadUsersSuccessUpdatesStateToLoaded() async throws {
        let mockService = MockUserService(users: try sampleUsers(), delayNanoseconds: 0)
        let viewModel = UserListViewModel(userService: mockService)

        await viewModel.loadUsers()

        #expect(viewModel.state == .loaded)
        #expect(viewModel.users.count == 2)
    }

    private func sampleUsers() throws -> [User] {
        let json = """
        [
          {
            "id": 1,
            "name": "Leanne Graham",
            "username": "Bret",
            "email": "Sincere@april.biz",
            "address": {
              "street": "Kulas Light",
              "suite": "Apt. 556",
              "city": "Gwenborough",
              "zipcode": "92998-3874",
              "geo": { "lat": "-37.3159", "lng": "81.1496" }
            },
            "phone": "1-770-736-8031 x56442",
            "website": "hildegard.org",
            "company": {
              "name": "Romaguera-Crona",
              "catchPhrase": "Multi-layered client-server neural-net",
              "bs": "harness real-time e-markets"
            }
          },
          {
            "id": 2,
            "name": "Ervin Howell",
            "username": "Antonette",
            "email": "Shanna@melissa.tv",
            "address": {
              "street": "Victor Plains",
              "suite": "Suite 879",
              "city": "Wisokyburgh",
              "zipcode": "90566-7771",
              "geo": { "lat": "-43.9509", "lng": "-34.4618" }
            },
            "phone": "010-692-6593 x09125",
            "website": "anastasia.net",
            "company": {
              "name": "Deckow-Crist",
              "catchPhrase": "Proactive didactic contingency",
              "bs": "synergize scalable supply-chains"
            }
          }
        ]
        """.data(using: .utf8)!
        return try JSONDecoder().decode([User].self, from: json)
    }

    @Test
    func loadUsersFailureSetsErrorWhenNoCachedData() async {
        let mockService = MockUserService(users: [], shouldFail: true, delayNanoseconds: 0)
        let viewModel = UserListViewModel(userService: mockService)

        await viewModel.loadUsers()

        if case .error = viewModel.state {
            #expect(viewModel.users.isEmpty)
        } else {
            Issue.record("Expected error state")
        }
    }

    @Test
    func searchFiltersUsersByNameEmailAndCity() async throws {
        let mockService = MockUserService(users: try sampleUsers(), delayNanoseconds: 0)
        let viewModel = UserListViewModel(userService: mockService)

        await viewModel.loadUsers()

        viewModel.searchText = "Gwenborough"
        #expect(viewModel.filteredUsers.count == 1)
        #expect(viewModel.filteredUsers.first?.name == "Leanne Graham")

        viewModel.searchText = "melissa"
        #expect(viewModel.filteredUsers.count == 1)
        #expect(viewModel.filteredUsers.first?.name == "Ervin Howell")
    }
}
