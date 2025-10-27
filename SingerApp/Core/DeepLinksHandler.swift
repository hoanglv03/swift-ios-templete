//
//  DeepLinksHandler.swift
//  SingerApp

import Foundation

enum DeepLink: Equatable {
    
    // Add your deep links here as needed
    // Examples:
    // case productDetail(productId: String)
    // case openCart
    // case showAccount
    
    case home // Example default case
    
    init?(url: URL) {
        guard
            let components = URLComponents(url: url, resolvingAgainstBaseURL: true),
            components.host == "www.example.com",
            let query = components.queryItems
        else { 
            // Default to home for now
            self = .home
            return 
        }
        
        // Add your URL parsing logic here
        // Example:
        // if let productId = query.first(where: { $0.name == "productId" })?.value {
        //     self = .productDetail(productId: productId)
        //     return
        // }
        
        self = .home
    }
}

// MARK: - DeepLinksHandler

@MainActor
protocol DeepLinksHandler {
    func open(deepLink: DeepLink)
}

struct RealDeepLinksHandler: DeepLinksHandler {
    
    private let container: DIContainer
    
    init(container: DIContainer) {
        self.container = container
    }
    
    func open(deepLink: DeepLink) {
        switch deepLink {
        case .home:
            let routeToDestination = {
                self.container.appState.bulkUpdate {
                    $0.routing.self
                }
            }
            /*
             SwiftUI is unable to perform complex navigation involving
             simultaneous dismissal or older screens and presenting new ones.
             A work around is to perform the navigation in two steps:
             */
            let defaultRouting = AppState.ViewRouting()
            if container.appState.value.routing != defaultRouting {
                self.container.appState[\.routing] = defaultRouting
                let delay: DispatchTime = .now() + (ProcessInfo.processInfo.isRunningTests ? 0 : 1.5)
                DispatchQueue.main.asyncAfter(deadline: delay, execute: routeToDestination)
            } else {
                routeToDestination()
            }
            
        // Add your deep link handling cases here as needed
        // Example:
        // case let .productDetail(productId):
        //     self.container.appState.bulkUpdate {
        //         $0.routing.productId = productId
        //     }
        }
    }
}
