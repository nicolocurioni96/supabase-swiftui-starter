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
        var imageUrl: String?

        if let image, let data = image.jpegData(compressionQuality: 0.8) {
            let fileName = "\(UUID().uuidString).jpg"
            let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            try data.write(to: fileURL)
            imageUrl = fileURL.absoluteString
        }

        let article = Article(
            id: UUID(),
            title: title,
            imageUrl: imageUrl,
            createdAt: Date()
        )
        articles.insert(article, at: 0)
    }
}
