//
//  MockData.swift
//  supabase-swiftui-starter
//
//  Created by Nicolo Curioni
//  Founder of withnico.com and codico.org
//

import Foundation

enum MockData {
    static let articles: [Article] = [
        Article(
            id: UUID(),
            title: "Getting Started with SwiftUI",
            imageUrl: nil,
            createdAt: Date().addingTimeInterval(-86400 * 1)
        ),
        Article(
            id: UUID(),
            title: "Understanding Supabase Auth",
            imageUrl: nil,
            createdAt: Date().addingTimeInterval(-86400 * 2)
        ),
        Article(
            id: UUID(),
            title: "Building a REST API with Edge Functions",
            imageUrl: nil,
            createdAt: Date().addingTimeInterval(-86400 * 3)
        ),
        Article(
            id: UUID(),
            title: "Real-time Subscriptions in Practice",
            imageUrl: nil,
            createdAt: Date().addingTimeInterval(-86400 * 5)
        ),
        Article(
            id: UUID(),
            title: "Deploying Your First iOS App",
            imageUrl: nil,
            createdAt: Date().addingTimeInterval(-86400 * 7)
        ),
    ]

    static let profile = Profile(
        id: UUID(),
        firstName: "John",
        lastName: "Appleseed",
        avatarUrl: nil
    )
}
