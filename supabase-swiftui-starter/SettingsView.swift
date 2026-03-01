//
//  SettingsView.swift
//  supabase-swiftui-starter
//
//  Created by Nicolò Curioni 🔸
//  Founder of withnico.com and codico.org
//

import SwiftUI

struct SettingsView: View {
    @Environment(DataSourceManager.self) private var dataSourceManager
    @State private var profile: Profile?

    private var service: any ProfileServiceProtocol {
        dataSourceManager.profileService()
    }

    var body: some View {
        @Bindable var manager = dataSourceManager

        NavigationStack {
            Form {
                Section {
                    NavigationLink {
                        ProfileView()
                    } label: {
                        HStack(spacing: 12) {
                            if let avatarUrl = profile?.avatarUrl, let url = URL(string: avatarUrl) {
                                AsyncImage(url: url) { phase in
                                    switch phase {
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .scaledToFill()
                                    default:
                                        profilePlaceholder
                                    }
                                }
                                .frame(width: 60, height: 60)
                                .clipShape(Circle())
                            } else {
                                profilePlaceholder
                            }

                            VStack(alignment: .leading, spacing: 2) {
                                Text(profileDisplayName)
                                    .font(.headline)
                                Text("Edit Profile")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }

                Section {
                    Toggle("Use Production Data", isOn: Binding(
                        get: { manager.isProduction },
                        set: { manager.dataSource = $0 ? .production : .mock }
                    ))
                } footer: {
                    Text("When off, the app uses local mock data. Turn on to fetch real data from Supabase.")
                }

                Section("Status") {
                    HStack {
                        Image(systemName: manager.isProduction ? "checkmark.cloud" : "internaldrive")
                            .foregroundStyle(manager.isProduction ? .green : .orange)
                            .imageScale(.large)

                        Text(manager.isProduction ? "Connected to Supabase" : "Using Mock Data")
                    }
                }
            }
            .navigationTitle("Settings")
            .task {
                await fetchProfile()
            }
            .onChange(of: dataSourceManager.dataSource) {
                Task { await fetchProfile() }
            }
        }
    }

    private var profileDisplayName: String {
        guard let profile else { return "Profile" }
        let name = "\(profile.firstName) \(profile.lastName)".trimmingCharacters(in: .whitespaces)
        return name.isEmpty ? "Profile" : name
    }

    private var profilePlaceholder: some View {
        Circle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 60, height: 60)
            .overlay {
                Image(systemName: "person.fill")
                    .font(.system(size: 24))
                    .foregroundStyle(.gray)
            }
    }

    private func fetchProfile() async {
        do {
            profile = try await service.fetchProfile()
        } catch {
            // Silently fail — profile row will show placeholder
        }
    }
}

#Preview {
    SettingsView()
        .environment(DataSourceManager())
}
