//
//  UserServiceTests.swift
//  FourteenZoneTaskTests
//
//  Created by Sabal on 6/12/26.
//

import Foundation
import Testing
@testable import FourteenZoneTask

@Suite(.serialized)
struct UserServiceTests {
    @Test
    func fetchUsersDecodesValidJSON() async throws {
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
          }
        ]
        """.data(using: .utf8)!

        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, json)
        }

        let session = URLSession(configuration: configuration)
        let cacheService = UserCacheService()
        let service = UserService(session: session, cacheService: cacheService)

        let users = try await service.fetchUsers()

        #expect(users.count == 1)
        #expect(users.first?.name == "Leanne Graham")
        #expect(service.getCachedUsers()?.first?.email == "Sincere@april.biz")
    }

    @Test
    func fetchUsersThrowsOnHTTPError() async {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [MockURLProtocol.self]
        MockURLProtocol.requestHandler = { request in
            let response = HTTPURLResponse(
                url: request.url!,
                statusCode: 500,
                httpVersion: nil,
                headerFields: nil
            )!
            return (response, Data())
        }

        let session = URLSession(configuration: configuration)
        let service = UserService(session: session, cacheService: UserCacheService())

        do {
            _ = try await service.fetchUsers()
            Issue.record("Expected HTTP error")
        } catch let error as NetworkError {
            #expect(error == .httpError(statusCode: 500))
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
}

final class MockURLProtocol: URLProtocol {
    nonisolated(unsafe) static var requestHandler: ((URLRequest) throws -> (HTTPURLResponse, Data))?

    override class func canInit(with request: URLRequest) -> Bool {
        request.url?.host == "jsonplaceholder.typicode.com"
    }

    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }

    override func startLoading() {
        guard let handler = MockURLProtocol.requestHandler else {
            client?.urlProtocol(self, didFailWithError: URLError(.badURL))
            return
        }

        do {
            let (response, data) = try handler(request)
            client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            client?.urlProtocol(self, didLoad: data)
            client?.urlProtocolDidFinishLoading(self)
        } catch {
            client?.urlProtocol(self, didFailWithError: error)
        }
    }

    override func stopLoading() {}
}
