//
//  MockedSystemPermissions.swift
//  SingerApp


import Foundation
import UserNotifications
@testable import SingerApp

final class MockedSystemPushNotifications: Mock, SystemNotificationsCenter {
    enum Action: Equatable {
        case currentSettings
        case requestAuthorization(UNAuthorizationOptions)
    }
    struct NotificationSettings: SystemNotificationsSettings {
        var authorizationStatus: UNAuthorizationStatus
    }
    var actions = MockActions<Action>(expected: [])
    var getResponses: [NotificationSettings] = []
    var requestResponses: [Result<Bool, Error>] = []

    init(expected: [Action]) {
        self.actions = .init(expected: expected)
    }

    func currentSettings() async -> any SystemNotificationsSettings {
        register(.currentSettings)
        guard !getResponses.isEmpty else {
            return NotificationSettings(authorizationStatus: .notDetermined)
        }
        return getResponses.removeFirst()
    }

    func requestAuthorization(options: UNAuthorizationOptions) async throws -> Bool {
        register(.requestAuthorization(options))
        guard !requestResponses.isEmpty else { throw MockError.valueNotSet }
        return try requestResponses.removeFirst().get()
    }
}
