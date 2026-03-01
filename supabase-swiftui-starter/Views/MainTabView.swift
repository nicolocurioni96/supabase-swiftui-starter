//
//  MainTabView.swift
//  supabase-swiftui-starter
//
//  Created by Nicolò Curioni 🔸
//  Founder of withnico.com and codico.org
//

import SwiftUI

struct MainTabView: View {
    var body: some View {
        TabView {
            Tab("News", systemImage: "newspaper") {
                ArticleListView()
            }

            Tab("Settings", systemImage: "gear") {
                SettingsView()
            }
        }
    }
}

#Preview {
    MainTabView()
        .environment(DataSourceManager())
}
