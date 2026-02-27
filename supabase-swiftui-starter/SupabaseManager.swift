//
//  SupabaseManager.swift
//  supabase-swiftui-starter
//
//  Created by Nicolo Curioni
//  Founder of withnico.com and codico.org
//

import Foundation
import Supabase

// MARK: - Replace the placeholders below with your own Supabase project credentials.
// You can find them in your Supabase dashboard under Settings > API.

enum SupabaseManager {
    private static let projectURL = URL(string: "https://YOUR_PROJECT_ID.supabase.co")!
    private static let anonKey = "YOUR_ANON_KEY_HERE"

    static let client = SupabaseClient(supabaseURL: projectURL, supabaseKey: anonKey)
}
