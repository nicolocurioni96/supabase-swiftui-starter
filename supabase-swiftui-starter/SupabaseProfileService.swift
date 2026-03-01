//
//  SupabaseProfileService.swift
//  supabase-swiftui-starter
//
//  Created by Nicolo Curioni
//  Founder of withnico.com and codico.org
//

import Foundation
import Supabase
import SwiftUI

class SupabaseProfileService: ProfileServiceProtocol {
    func fetchProfile() async throws -> Profile? {
        let profiles: [Profile] = try await SupabaseManager.client
            .from("profile")
            .select()
            .limit(1)
            .execute()
            .value

        return profiles.first
    }

    func updateProfile(_ profile: Profile, firstName: String, lastName: String, avatarImage: UIImage?) async throws {
        var avatarUrl = profile.avatarUrl

        if let avatarImage, let data = avatarImage.jpegData(compressionQuality: 0.8) {
            let fileName = "avatar-\(profile.id.uuidString).jpg"

            try await SupabaseManager.client.storage
                .from("avatars")
                .upload(fileName, data: data, options: .init(contentType: "image/jpeg", upsert: true))

            let publicURL = try SupabaseManager.client.storage
                .from("avatars")
                .getPublicURL(path: fileName)

            avatarUrl = publicURL.absoluteString
        }

        let update = ProfileUpdate(firstName: firstName, lastName: lastName, avatarUrl: avatarUrl)

        try await SupabaseManager.client
            .from("profile")
            .update(update)
            .eq("id", value: profile.id.uuidString)
            .execute()
    }
}
