//
//  SupabaseStarterApp.swift
//  supabase-swiftui-starter
//
//  Created by Nicolò Curioni 🔸
//  Founder of withnico.com and codico.org
//

import SwiftUI

@main
struct SupabaseStarterApp: App {
    @State private var dataSourceManager = DataSourceManager()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(dataSourceManager)
        }
    }
}
