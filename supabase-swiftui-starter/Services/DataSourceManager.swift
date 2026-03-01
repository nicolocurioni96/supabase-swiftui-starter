//
//  DataSourceManager.swift
//  supabase-swiftui-starter
//
//  Created by Nicolò Curioni 🔸
//  Founder of withnico.com and codico.org
//

import Foundation

enum DataSource {
    case production
    case mock
}

@Observable
class DataSourceManager {
    var dataSource: DataSource = .mock

    var isProduction: Bool {
        dataSource == .production
    }

    private let mockArticleService = MockArticleService()
    private let mockProfileService = MockProfileService()
    private let supabaseArticleService = SupabaseArticleService()
    private let supabaseProfileService = SupabaseProfileService()

    func articleService() -> any ArticleServiceProtocol {
        switch dataSource {
        case .production:
            supabaseArticleService
        case .mock:
            mockArticleService
        }
    }

    func profileService() -> any ProfileServiceProtocol {
        switch dataSource {
        case .production:
            supabaseProfileService
        case .mock:
            mockProfileService
        }
    }
}
