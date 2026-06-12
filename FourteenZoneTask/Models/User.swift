//
//  User.swift
//  FourteenZoneTask
//
//  Created by Sabal on 6/12/26.
//

import Foundation

struct User: Identifiable, Codable, Hashable, Sendable {
    let id: Int
    let name: String
    let username: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company

    struct Address: Codable, Hashable, Sendable {
        let street: String
        let suite: String
        let city: String
        let zipcode: String
        let geo: Geo

        struct Geo: Codable, Hashable, Sendable {
            let lat: String
            let lng: String
        }
    }

    struct Company: Codable, Hashable, Sendable {
        let name: String
        let catchPhrase: String
        let bs: String
    }
}

#if DEBUG
extension User {
    static let preview = User(
        id: 1,
        name: "Leanne Graham",
        username: "Bret",
        email: "Sincere@april.biz",
        address: Address(
            street: "Kulas Light",
            suite: "Apt. 556",
            city: "Gwenborough",
            zipcode: "92998-3874",
            geo: Address.Geo(lat: "-37.3159", lng: "81.1496")
        ),
        phone: "1-770-736-8031 x56442",
        website: "hildegard.org",
        company: Company(
            name: "Romaguera-Crona",
            catchPhrase: "Multi-layered client-server neural-net",
            bs: "harness real-time e-markets"
        )
    )

    static let previewList: [User] = [
        preview,
        User(
            id: 2,
            name: "Ervin Howell",
            username: "Antonette",
            email: "Shanna@melissa.tv",
            address: Address(
                street: "Victor Plains",
                suite: "Suite 879",
                city: "Wisokyburgh",
                zipcode: "90566-7771",
                geo: Address.Geo(lat: "-43.9509", lng: "-34.4618")
            ),
            phone: "010-692-6593 x09125",
            website: "anastasia.net",
            company: Company(
                name: "Deckow-Crist",
                catchPhrase: "Proactive didactic contingency",
                bs: "synergize scalable supply-chains"
            )
        )
    ]
}
#endif
