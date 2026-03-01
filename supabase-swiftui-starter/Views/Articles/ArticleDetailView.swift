//
//  ArticleDetailView.swift
//  supabase-swiftui-starter
//
//  Created by Nicolò Curioni 🔸
//  Founder of withnico.com and codico.org
//

import SwiftUI

struct ArticleDetailView: View {
    let article: Article

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let imageUrl = article.imageUrl, let url = URL(string: imageUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        default:
                            Color.gray
                                .frame(height: 220)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }

                Text(article.title)
                    .font(.title)
                    .fontWeight(.bold)

                Label(article.createdAt.formatted(date: .long, time: .shortened), systemImage: "calendar")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle("Detail")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ArticleDetailView(article: MockData.articles[0])
    }
}
