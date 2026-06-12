//
//  UserCacheService.swift
//  FourteenZoneTask
//
//  Created by Sabal on 6/12/26.
//

import Foundation

protocol UserCacheServiceProtocol: Sendable {
    func saveUsers(_ users: [User])
    func loadUsers() -> [User]?
    func clearCache()
}

final class UserCacheService: UserCacheServiceProtocol, @unchecked Sendable {
    private let fileManager: FileManager
    private let cacheFileName = "cached_users.json"

    init(fileManager: FileManager = .default) {
        self.fileManager = fileManager
    }

    private var cacheURL: URL {
        fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
            .appendingPathComponent(cacheFileName)
    }

    func saveUsers(_ users: [User]) {
        guard let data = try? JSONEncoder().encode(users) else { return }
        try? data.write(to: cacheURL, options: .atomic)
    }

    func loadUsers() -> [User]? {
        guard fileManager.fileExists(atPath: cacheURL.path),
              let data = try? Data(contentsOf: cacheURL) else {
            return nil
        }
        return try? JSONDecoder().decode([User].self, from: data)
    }

    func clearCache() {
        try? fileManager.removeItem(at: cacheURL)
    }
}
