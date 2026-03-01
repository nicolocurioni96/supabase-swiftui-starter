//
//  Models.swift
//  supabase-swiftui-starter
//
//  Created by Nicolò Curioni 🔸
//  Founder of withnico.com and codico.org
//

import Foundation

struct Article: Codable, Identifiable {
    let id: UUID
    let title: String
    let imageUrl: String?
    let createdAt: Date

    enum CodingKeys: String, CodingKey {
        case id, title
        case imageUrl = "image_url"
        case createdAt = "created_at"
    }
}

struct NewArticle: Codable {
    let title: String
    let imageUrl: String?

    enum CodingKeys: String, CodingKey {
        case title
        case imageUrl = "image_url"
    }
}

struct Profile: Codable, Identifiable {
    let id: UUID
    let firstName: String
    let lastName: String
    let avatarUrl: String?

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case avatarUrl = "avatar_url"
    }
}

struct ProfileUpdate: Codable {
    let firstName: String
    let lastName: String
    let avatarUrl: String?

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case avatarUrl = "avatar_url"
    }
}
