//
//  AddArticleView.swift
//  supabase-swiftui-starter
//
//  Created by Nicolo Curioni
//  Founder of withnico.com and codico.org
//

import PhotosUI
import SwiftUI

struct AddArticleView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(DataSourceManager.self) private var dataSourceManager

    @State private var title = ""
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var isSaving = false
    @State private var errorMessage: String?

    var onSave: () -> Void

    private var service: any ArticleServiceProtocol {
        dataSourceManager.articleService()
    }

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
            try await service.createArticle(title: title, image: selectedImage)
            onSave()
            dismiss()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

#Preview {
    AddArticleView { }
        .environment(DataSourceManager())
}
