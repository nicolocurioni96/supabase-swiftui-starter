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
        self.profile = Profile(
            id: profile.id,
            firstName: firstName,
            lastName: lastName,
            avatarUrl: profile.avatarUrl
        )
    }
}
