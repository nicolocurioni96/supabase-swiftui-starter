//
//  ArticleRowView.swift
//  supabase-swiftui-starter
//
//  Created by Nicolò Curioni 🔸
//  Founder of withnico.com and codico.org
//

import SwiftUI

struct ArticleRowView: View {
    let article: Article

    var body: some View {
        HStack(spacing: 12) {
            if let imageUrl = article.imageUrl, let url = URL(string: imageUrl) {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image):
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    default:
                        Color.gray
                    }
                }
                .frame(width: 80, height: 80)
                .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                Color.gray
                    .frame(width: 80, height: 80)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(article.title)
                    .font(.headline)
                    .lineLimit(2)

                Text(article.createdAt, format: .dateTime.day().month().year())
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    ArticleRowView(article: MockData.articles[0])
}
