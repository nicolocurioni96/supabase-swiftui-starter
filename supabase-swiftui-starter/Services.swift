//
//  Services.swift
//  supabase-swiftui-starter
//
//  Created by Nicolò Curioni 🔸
//  Founder of withnico.com and codico.org
//

import Foundation
import SwiftUI

protocol ArticleServiceProtocol {
    func fetchArticles() async throws -> [Article]
    func deleteArticle(_ article: Article) async throws
    func createArticle(title: String, image: UIImage?) async throws
}

protocol ProfileServiceProtocol {
    func fetchProfile() async throws -> Profile?
    func updateProfile(_ profile: Profile, firstName: String, lastName: String, avatarImage: UIImage?) async throws
}
