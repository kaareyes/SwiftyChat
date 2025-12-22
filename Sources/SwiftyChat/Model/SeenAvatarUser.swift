//
//  Untitled.swift
//  SwiftyChat
//
//  Created by 1gz on 12/22/25.
//

import Foundation

public final class SeenAvatarUser: Identifiable, Hashable {

    public let id: String
    public let name: String
    public let imageUrl: URL?

    public init(id: String, name: String, imageUrl: URL?) {
        self.id = id
        self.name = name
        self.imageUrl = imageUrl
    }

    public static func == (lhs: SeenAvatarUser, rhs: SeenAvatarUser) -> Bool {
        lhs.id == rhs.id
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
