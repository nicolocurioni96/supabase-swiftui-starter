//
//  MockArticleService.swift
//  supabase-swiftui-starter
//
//  Created by Nicolò Curioni 🔸
//  Founder of withnico.com and codico.org
//

import Foundation
import SwiftUI

class MockArticleService: ArticleServiceProtocol {
    var articles: [Article] = MockData.articles

    func fetchArticles() async throws -> [Article] {
        articles.sorted { $0.createdAt > $1.createdAt }
    }

    func deleteArticle(_ article: Article) async throws {
        articles.removeAll { $0.id == article.id }
    }

    func createArticle(title: String, image: UIImage?) async throws {
        let article = Article(
            id: UUID(),
            title: title,
            imageUrl: nil,
            createdAt: Date()
        )
        articles.insert(article, at: 0)
    }
}
