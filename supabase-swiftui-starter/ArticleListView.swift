//
//  ArticleListView.swift
//  supabase-swiftui-starter
//
//  Created by Nicolo Curioni
//  Founder of withnico.com and codico.org
//

import SwiftUI

struct ArticleListView: View {
    @Environment(DataSourceManager.self) private var dataSourceManager
    @State private var articles: [Article] = []
    @State private var isLoading = false
    @State private var showAddArticle = false
    @State private var errorMessage: String?

    private var service: any ArticleServiceProtocol {
        dataSourceManager.articleService()
    }

    var body: some View {
        NavigationStack {
            Group {
                if isLoading && articles.isEmpty {
                    ProgressView()
                } else if articles.isEmpty {
                    ContentUnavailableView(
                        "No articles",
                        systemImage: "newspaper",
                        description: Text("Tap + to add your first article")
                    )
                } else {
                    List {
                        ForEach(articles) { article in
                            ArticleRowView(article: article)
                        }
                        .onDelete(perform: deleteArticles)
                    }
                    .refreshable {
                        await fetchArticles()
                    }
                }
            }
            .navigationTitle("Articles")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        showAddArticle = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showAddArticle) {
                AddArticleView {
                    Task { await fetchArticles() }
                }
            }
            .task {
                await fetchArticles()
            }
            .onChange(of: dataSourceManager.dataSource) {
                Task { await fetchArticles() }
            }
            .alert("Error", isPresented: .init(
                get: { errorMessage != nil },
                set: { if !$0 { errorMessage = nil } }
            )) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage ?? "")
            }
        }
    }

    private func fetchArticles() async {
        isLoading = true
        defer { isLoading = false }

        do {
            articles = try await service.fetchArticles()
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func deleteArticles(at offsets: IndexSet) {
        Task {
            do {
                for index in offsets {
                    let article = articles[index]
                    try await service.deleteArticle(article)
                }

                await fetchArticles()
            } catch {
                errorMessage = error.localizedDescription
            }
        }
    }
}

#Preview {
    ArticleListView()
        .environment(DataSourceManager())
}
