//
//  MockProfileService.swift
//  supabase-swiftui-starter
//
//  Created by Nicolò Curioni 🔸
//  Founder of withnico.com and codico.org
//

import Foundation
import SwiftUI

class MockProfileService: ProfileServiceProtocol {
    var profile: Profile = MockData.profile

    func fetchProfile() async throws -> Profile? {
        profile
    }

    func updateProfile(_ profile: Profile, firstName: String, lastName: String, avatarImage: UIImage?) async throws {
        var avatarUrl = profile.avatarUrl

        if let avatarImage, let data = avatarImage.jpegData(compressionQuality: 0.8) {
            let fileName = "avatar-\(profile.id.uuidString).jpg"
            let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
            try data.write(to: fileURL)
            avatarUrl = fileURL.absoluteString
        }

        self.profile = Profile(
            id: profile.id,
            firstName: firstName,
            lastName: lastName,
            avatarUrl: avatarUrl
        )
    }
}
