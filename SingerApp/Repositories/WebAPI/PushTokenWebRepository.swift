//
//  PushTokenWebRepository.swift
//  SingerApp


import Foundation

protocol PushTokenWebRepository: WebRepository {
    func register(devicePushToken: Data) async throws
}

struct RealPushTokenWebRepository: PushTokenWebRepository {
    
    let session: URLSession
    let baseURL: String
    
    init(session: URLSession) {
        self.session = session
        // Get base URL from environment config
        let config = EnvironmentConfig.shared
        self.baseURL = config.value(for: "PUSH_TOKEN_ENDPOINT") ?? config.apiBaseURL
    }
    
    func register(devicePushToken: Data) async throws {
        // upload the push token to your server
        // you can as well call a third party library here instead
    }
}
