//
//  SupabaseSwiftUIStarterApp.swift
//  supabase-swiftui-starter
//
//  Created by Nicolò Curioni 🔸
//  Founder of withnico.com and codico.org
//

import SwiftUI

@main
struct SupabaseSwiftUIStarterApp: App {
    @State private var dataSourceManager = DataSourceManager()

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(dataSourceManager)
        }
    }
}
