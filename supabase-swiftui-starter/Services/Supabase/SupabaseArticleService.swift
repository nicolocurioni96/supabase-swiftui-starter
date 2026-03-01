//
//  SupabaseArticleService.swift
//  supabase-swiftui-starter
//
//  Created by Nicolò Curioni 🔸
//  Founder of withnico.com and codico.org
//

import Foundation
import Supabase
import SwiftUI

class SupabaseArticleService: ArticleServiceProtocol {
    func fetchArticles() async throws -> [Article] {
        try await SupabaseManager.client
            .from("articles")
            .select()
            .order("created_at", ascending: false)
            .execute()
            .value
    }

    func deleteArticle(_ article: Article) async throws {
        if let imageUrl = article.imageUrl,
           let fileName = URL(string: imageUrl)?.lastPathComponent {
            try await SupabaseManager.client.storage
                .from("article-images")
                .remove(paths: [fileName])
        }

        try await SupabaseManager.client
            .from("articles")
            .delete()
            .eq("id", value: article.id.uuidString)
            .execute()
    }

    func createArticle(title: String, image: UIImage?) async throws {
        var imageUrl: String?

        if let image, let data = image.jpegData(compressionQuality: 0.8) {
            let fileName = "\(UUID().uuidString).jpg"

            try await SupabaseManager.client.storage
                .from("article-images")
                .upload(fileName, data: data, options: .init(contentType: "image/jpeg"))

            let publicURL = try SupabaseManager.client.storage
                .from("article-images")
                .getPublicURL(path: fileName)

            imageUrl = publicURL.absoluteString
        }

        let newArticle = NewArticle(title: title, imageUrl: imageUrl)

        try await SupabaseManager.client
            .from("articles")
            .insert(newArticle)
            .execute()
    }
}
