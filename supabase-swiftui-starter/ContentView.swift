//
//  ContentView.swift
//  supabase-swiftui-starter
//
//  Created by Nicolo Curioni
//  Founder of withnico.com and codico.org
//

import SwiftUI

struct ContentView: View {
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
    ContentView()
        .environment(DataSourceManager())
}
