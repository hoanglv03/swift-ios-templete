import SwiftUI
import Combine

struct AppState: Equatable {
    var routing = ViewRouting()
    var system = System()
    var permissions = Permissions()
}

extension AppState {
    struct ViewRouting: Equatable {
        // Add routing state here when needed
        // Examples for future deep links:
        // var home: HomeRouting?
        // var productId: String?
        // var showCart: Bool = false
    }
}

extension AppState {
    struct System: Equatable {
        var isActive: Bool = false
        var keyboardHeight: CGFloat = 0
    }
}

extension AppState {
    struct Permissions: Equatable {
        var push: Permission.Status = .unknown
    }

    static func permissionKeyPath(for permission: Permission) -> WritableKeyPath<AppState, Permission.Status> {
        let pathToPermissions = \AppState.permissions
        switch permission {
        case .pushNotifications:
            return pathToPermissions.appending(path: \.push)
        }
    }
}

func == (lhs: AppState, rhs: AppState) -> Bool {
    return lhs.routing == rhs.routing
        && lhs.system == rhs.system
        && lhs.permissions == rhs.permissions
}
