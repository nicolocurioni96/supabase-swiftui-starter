//
//  AddArticleView.swift
//  supabase-swiftui-starter
//
//  Created by Nicolo Curioni
//  Founder of withnico.com and codico.org
//

import PhotosUI
import Supabase
import SwiftUI

struct AddArticleView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var title = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var isSaving = false
    @State private var errorMessage: String?

    var onSave: () -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Article title", text: $title)
                }

                Section("Image") {
                    PhotosPicker(selection: $selectedPhoto, matching: .images) {
                        if let selectedImage {
                            Image(uiImage: selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(maxHeight: 200)
                        } else {
                            Label("Choose an image", systemImage: "photo")
                        }
                    }
                }
            }
            .navigationTitle("New Article")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        Task { await save() }
                    }
                    .disabled(title.isEmpty || isSaving)
                }
            }
            .overlay {
                if isSaving {
                    ProgressView()
                }
            }
            .onChange(of: selectedPhoto) { _, newItem in
                Task {
                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                        selectedImage = UIImage(data: data)
                    }
                }
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

    private func save() async {
        isSaving = true
        defer { isSaving = false }

        do {
            var imageUrl: String?

            if let selectedImage, let data = selectedImage.jpegData(compressionQuality: 0.8) {
                let fileName = "\(UUID().uuidString).jpg"

                try await SupabaseManager.client.storage
                    .from("article-images")
                    .upload(fileName, data: data, options: .init(contentType: "image/jpeg"))

                let publicURL = try SupabaseManager.client.storage
                    .from("article-images")
                    .getPublicURL(path: fileName)

                imageUrl = publicURL.absoluteString
            }

            let newArticle = NewArticle(title: title, imageUrl: imageUrl)

            try await SupabaseManager.client
                .from("articles")
                .insert(newArticle)
                .execute()

            onSave()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
