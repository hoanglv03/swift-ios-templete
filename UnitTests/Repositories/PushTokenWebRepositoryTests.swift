//
//  PushTokenWebRepositoryTests.swift
//  UnitTests


import Testing
import Foundation
@testable import SingerApp

@Suite struct PushTokenWebRepositoryTests {

    private let sut = RealPushTokenWebRepository(session: .mockedResponsesOnly)

    @Test func register() async throws {
        try await sut.register(devicePushToken: Data())
    }
}

