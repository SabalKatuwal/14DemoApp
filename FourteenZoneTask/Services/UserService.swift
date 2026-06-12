//
//  UserService.swift
//  FourteenZoneTask
//
//  Created by Sabal on 6/12/26.
//

import Foundation

protocol UserServiceProtocol: Sendable {
    func fetchUsers() async throws -> [User]
    func getCachedUsers() -> [User]?
}

final class UserService: UserServiceProtocol, @unchecked Sendable {
    private let session: URLSession
    private let cacheService: UserCacheServiceProtocol

    init(
        session: URLSession = .shared,
        cacheService: UserCacheServiceProtocol = UserCacheService()
    ) {
        self.session = session
        self.cacheService = cacheService
    }

    func getCachedUsers() -> [User]? {
        cacheService.loadUsers()
    }

    func fetchUsers() async throws -> [User] {
        guard let url = URL(string: APIConstants.usersEndpoint) else {
            throw NetworkError.invalidURL
        }

        let (data, response) = try await session.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.httpError(statusCode: httpResponse.statusCode)
        }

        do {
            let users = try JSONDecoder().decode([User].self, from: data)
            cacheService.saveUsers(users)
            return users
        } catch {
            throw NetworkError.decodingFailed
        }
    }
}

struct MockUserService: UserServiceProtocol {
    var users: [User] = []
    var shouldFail = false
    var delayNanoseconds: UInt64 = 500_000_000

    init(
        users: [User] = [],
        shouldFail: Bool = false,
        delayNanoseconds: UInt64 = 500_000_000
    ) {
        self.users = users
        self.shouldFail = shouldFail
        self.delayNanoseconds = delayNanoseconds
    }

    func fetchUsers() async throws -> [User] {
        try await Task.sleep(nanoseconds: delayNanoseconds)
        if shouldFail {
            throw NetworkError.invalidResponse
        }
        return users
    }

    func getCachedUsers() -> [User]? {
        users.isEmpty ? nil : users
    }
}

#if DEBUG
extension MockUserService {
    static var preview: MockUserService {
        MockUserService(users: User.previewList)
    }
}
#endif
