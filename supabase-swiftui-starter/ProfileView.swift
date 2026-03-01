//
//  ProfileView.swift
//  supabase-swiftui-starter
//
//  Created by Nicolo Curioni
//  Founder of withnico.com and codico.org
//

import PhotosUI
import SwiftUI

struct ProfileView: View {
    @Environment(DataSourceManager.self) private var dataSourceManager
    @State private var profile: Profile?
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var avatarImage: UIImage?
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var isLoading = false
    @State private var isSaving = false
    @State private var errorMessage: String?
    @State private var showSavedAlert = false

    private var service: any ProfileServiceProtocol {
        dataSourceManager.profileService()
    }

    var body: some View {
        Form {
            Section {
                VStack {
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        if let avatarImage {
                            Image(uiImage: avatarImage)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 120, height: 120)
                                .clipShape(Circle())
                        } else if let avatarUrl = profile?.avatarUrl, let url = URL(string: avatarUrl) {
                            AsyncImage(url: url) { phase in
                                switch phase {
                                case .success(let image):
                                    image
                                        .resizable()
                                        .scaledToFill()
                                default:
                                    placeholderCircle
                                }
                            }
                            .frame(width: 120, height: 120)
                            .clipShape(Circle())
                        } else {
                            placeholderCircle
                        }
                    }

                    Text("Tap to change photo")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .frame(maxWidth: .infinity)
            }

            Section("Information") {
                TextField("First Name", text: $firstName)
                TextField("Last Name", text: $lastName)
            }

            Section {
                Button {
                    Task { await saveProfile() }
                } label: {
                    if isSaving {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text("Save Profile")
                            .frame(maxWidth: .infinity)
                    }
                }
                .disabled(isSaving)
            }
        }
        .navigationTitle("Profile")
        .task {
            await fetchProfile()
        }
        .onChange(of: dataSourceManager.dataSource) {
            Task { await fetchProfile() }
        }
        .onChange(of: selectedPhoto) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    avatarImage = UIImage(data: data)
                }
            }
        }
        .alert("Saved!", isPresented: $showSavedAlert) {
            Button("OK", role: .cancel) {}
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

    private var placeholderCircle: some View {
        Circle()
            .fill(Color.gray.opacity(0.3))
            .frame(width: 120, height: 120)
            .overlay {
                Image(systemName: "person.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.gray)
            }
    }

    private func fetchProfile() async {
        isLoading = true
        defer { isLoading = false }

        do {
            if let fetched = try await service.fetchProfile() {
                profile = fetched
                firstName = fetched.firstName
                lastName = fetched.lastName
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func saveProfile() async {
        guard let profile else { return }

        isSaving = true
        defer { isSaving = false }

        do {
            try await service.updateProfile(profile, firstName: firstName, lastName: lastName, avatarImage: avatarImage)
            showSavedAlert = true
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
    .environment(DataSourceManager())
}
