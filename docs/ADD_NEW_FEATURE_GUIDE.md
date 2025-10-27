# 📖 Guide: Adding a New Interactor and Repository

## 🎯 Overview

To add a new feature with Interactor and Repository, you need to follow **6 steps**:

1. ✅ Create Repository Protocol and Implementation
2. ✅ Create Interactor Protocol and Implementation  
3. ✅ Register in DIContainer
4. ✅ Initialize in AppEnvironment
5. ✅ Add Stub for testing
6. ✅ Use in View

---

## 📝 Example: Adding "Users" Feature

### **Step 1: Create WebRepository** 

📁 File: `SingerApp/Repositories/WebAPI/UsersWebRepository.swift`

```swift
//
//  UsersWebRepository.swift
//  SingerApp
//

import Foundation

protocol UsersWebRepository: WebRepository {
    func fetchUsers() async throws -> [ApiModel.User]
    func fetchUserDetails(userId: String) async throws -> ApiModel.UserDetails
}

struct RealUsersWebRepository: UsersWebRepository {
    
    let session: URLSession
    let baseURL: String
    
    init(session: URLSession) {
        self.session = session
        self.baseURL = EnvironmentConfig.shared.apiBaseURL
    }
    
    func fetchUsers() async throws -> [ApiModel.User] {
        return try await call(endpoint: API.users)
    }
    
    func fetchUserDetails(userId: String) async throws -> ApiModel.UserDetails {
        return try await call(endpoint: API.userDetails(userId: userId))
    }
}

// MARK: - Endpoints

extension RealUsersWebRepository {
    enum API {
        case users
        case userDetails(userId: String)
    }
}

extension RealUsersWebRepository.API: APICall {
    var path: String {
        switch self {
        case .users:
            return "/users"
        case let .userDetails(userId):
            return "/users/\(userId)"
        }
    }
    
    var method: String {
        switch self {
        case .users, .userDetails:
            return "GET"
        }
    }
    
    var headers: [String: String]? {
        return ["Accept": "application/json"]
    }
    
    func body() throws -> Data? {
        return nil
    }
}
```

---

### **Step 2: Create Database Model and Repository**

📁 File: `SingerApp/Repositories/Models/User.swift`

```swift
//
//  User.swift
//  SingerApp
//

import Foundation
import SwiftData

// MARK: - Database Model

extension DBModel {
    @Model final class User {
        @Attribute(.unique) var id: String
        var name: String
        var email: String
        var avatar: URL?
        
        init(id: String, name: String, email: String, avatar: URL?) {
            self.id = id
            self.name = name
            self.email = email
            self.avatar = avatar
        }
    }
}

// MARK: - Web API Model

extension ApiModel {
    struct User: Codable, Equatable {
        let id: String
        let name: String
        let email: String
        let avatar: URL?
    }
    
    struct UserDetails: Codable, Equatable {
        let id: String
        let name: String
        let email: String
        let bio: String
        let joinDate: Date
    }
}
```

📁 File: `SingerApp/Repositories/Database/UsersDBRepository.swift`

```swift
//
//  UsersDBRepository.swift
//  SingerApp
//

import SwiftData
import Foundation

protocol UsersDBRepository {
    @MainActor
    func fetchUsers() async throws -> [DBModel.User]
    func store(users: [ApiModel.User]) async throws
    func fetchUserDetails(for userId: String) async throws -> DBModel.User?
}

@MainActor
extension MainDBRepository: UsersDBRepository {
    
    func fetchUsers() async throws -> [DBModel.User] {
        let fetchDescriptor = FetchDescriptor<DBModel.User>(sortBy: [SortDescriptor(\.name)])
        return try modelContainer.mainContext.fetch(fetchDescriptor)
    }
    
    func store(users: [ApiModel.User]) async throws {
        try modelContext.transaction {
            users
                .map { $0.dbModel() }
                .forEach {
                    modelContext.insert($0)
                }
        }
    }
    
    func fetchUserDetails(for userId: String) async throws -> DBModel.User? {
        let fetchDescriptor = FetchDescriptor(predicate: #Predicate<DBModel.User> {
            $0.id == userId
        })
        return try modelContainer.mainContext.fetch(fetchDescriptor).first
    }
}

// MARK: - Model Conversion

internal extension ApiModel.User {
    func dbModel() -> DBModel.User {
        return .init(
            id: id,
            name: name,
            email: email,
            avatar: avatar
        )
    }
}
```

📁 **Update Schema**: `SingerApp/Repositories/Models/AppSchema.swift`

**Note**: Add DBModel.User to the schema list

```swift
extension Schema {
    private static var actualVersion: Schema.Version = Version(1, 0, 0)

    static var appSchema: Schema {
        Schema([
            DBModel.Country.self,
            DBModel.CountryDetails.self,
            DBModel.Currency.self,
            DBModel.User.self,  // ◄─── ADD THIS LINE
        ], version: actualVersion)
    }
}
```

---

### **Step 3: Create Interactor**

📁 File: `SingerApp/Interactors/UsersInteractor.swift`

```swift
//
//  UsersInteractor.swift
//  SingerApp
//

protocol UsersInteractor {
    func refreshUsersList() async throws
    func loadUserDetails(userId: String, forceReload: Bool) async throws -> DBModel.User
}

struct RealUsersInteractor: UsersInteractor {
    
    let webRepository: UsersWebRepository
    let dbRepository: UsersDBRepository
    
    func refreshUsersList() async throws {
        let apiUsers = try await webRepository.fetchUsers()
        try await dbRepository.store(users: apiUsers)
    }
    
    func loadUserDetails(userId: String, forceReload: Bool) async throws -> DBModel.User {
        // Check cache first
        if !forceReload, let cached = try? await dbRepository.fetchUserDetails(for: userId) {
            return cached
        }
        
        // Fetch from API
        let details = try await webRepository.fetchUserDetails(userId: userId)
        
        // Store to cache
        try await dbRepository.store(users: [details])
        
        // Return from database
        guard let stored = try await dbRepository.fetchUserDetails(for: userId) else {
            throw ValueIsMissingError()
        }
        return stored
    }
}

struct StubUsersInteractor: UsersInteractor {
    
    func refreshUsersList() async throws {
        // Stub implementation for testing
    }
    
    func loadUserDetails(userId: String, forceReload: Bool) async throws -> DBModel.User {
        throw ValueIsMissingError()
    }
}
```

---

### **Step 4: Register in DIContainer**

📁 File: `SingerApp/DependencyInjection/DIContainer.swift`

```swift
extension DIContainer {
    struct WebRepositories {
        let images: ImagesWebRepository
        let countries: CountriesWebRepository
        let pushToken: PushTokenWebRepository
        let users: UsersWebRepository  // ◄─── ADD THIS LINE
    }
    
    struct DBRepositories {
        let countries: CountriesDBRepository
        let users: UsersDBRepository  // ◄─── ADD THIS LINE
    }
    
    struct Interactors {
        let images: ImagesInteractor
        let countries: CountriesInteractor
        let userPermissions: UserPermissionsInteractor
        let users: UsersInteractor  // ◄─── ADD THIS LINE

        static var stub: Self {
            .init(images: StubImagesInteractor(),
                  countries: StubCountriesInteractor(),
                  userPermissions: StubUserPermissionsInteractor(),
                  users: StubUsersInteractor())  // ◄─── ADD THIS LINE
        }
    }
}
```

---

### **Step 5: Initialize in AppEnvironment**

📁 File: `SingerApp/DependencyInjection/AppEnvironment.swift`

```swift
    private static func configuredWebRepositories(session: URLSession) -> DIContainer.WebRepositories {
        let images = RealImagesWebRepository(session: session)
        let countries = RealCountriesWebRepository(session: session)
        let pushToken = RealPushTokenWebRepository(session: session)
        let users = RealUsersWebRepository(session: session)  // ◄─── ADD THIS LINE
        
        return .init(images: images,
                     countries: countries,
                     pushToken: pushToken,
                     users: users)  // ◄─── ADD THIS LINE
    }

    private static func configuredDBRepositories(modelContainer: ModelContainer) -> DIContainer.DBRepositories {
        let mainDBRepository = MainDBRepository(modelContainer: modelContainer)
        return .init(countries: mainDBRepository,
                      users: mainDBRepository)  // ◄─── UPDATE THIS LINE
    }

    private static func configuredInteractors(
        appState: Store<AppState>,
        webRepositories: DIContainer.WebRepositories,
        dbRepositories: DIContainer.DBRepositories
    ) -> DIContainer.Interactors {
        let images = RealImagesInteractor(webRepository: webRepositories.images)
        let countries = RealCountriesInteractor(
            webRepository: webRepositories.countries,
            dbRepository: dbRepositories.countries)
        let userPermissions = RealUserPermissionsInteractor(
            appState: appState, openAppSettings: {
                URL(string: UIApplication.openSettingsURLString).flatMap {
                    UIApplication.shared.open($0, options: [:], completionHandler: nil)
                }
            })
        let users = RealUsersInteractor(  // ◄─── ADD THIS LINE
            webRepository: webRepositories.users,
            dbRepository: dbRepositories.users)
        
        return .init(images: images,
                     countries: countries,
                     userPermissions: userPermissions,
                     users: users)  // ◄─── ADD THIS LINE
    }
```

---

### **Step 6: Use in View**

📁 File: `SingerApp/UI/UsersList/UsersListView.swift`

```swift
//
//  UsersListView.swift
//  SingerApp
//

import SwiftUI
import SwiftData

struct UsersListView: View {
    
    @State private var users: [DBModel.User] = []
    @State private var usersState: Loadable<Void> = .notRequested
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        NavigationView {
            content
                .navigationTitle("Users")
                .onAppear {
                    loadUsers()
                }
        }
    }
    
    @ViewBuilder
    private var content: some View {
        switch usersState {
        case .notRequested, .isLoading:
            ProgressView()
        case .loaded:
            List(users, id: \.id) { user in
                Text(user.name)
            }
        case .failed(let error):
            ErrorView(error: error, retryAction: loadUsers)
        }
    }
    
    private func loadUsers() {
        $usersState.load {
            try await injected.interactors.users.refreshUsersList()
        }
    }
}
```

---

## ✅ Checklist

- [ ] Create WebRepository protocol and implementation
- [ ] Create DB model and Repository protocol  
- [ ] Update AppSchema.swift with new model
- [ ] Create Interactor protocol and implementation
- [ ] Create Stub for testing
- [ ] Update DIContainer.WebRepositories
- [ ] Update DIContainer.DBRepositories  
- [ ] Update DIContainer.Interactors
- [ ] Update AppEnvironment.bootstrap() to initialize
- [ ] Create View to use
- [ ] Add unit tests

---

## 🎯 General Pattern

```
Repository (Data Layer)
    ↓
Interactor (Business Logic)
    ↓  
DIContainer (Dependency Injection)
    ↓
AppEnvironment (Bootstrap)
    ↓
View (UI Layer)
```

All dependencies are injected through `@Environment(\.injected)`

---

## 📚 Existing Examples

Check the current implementations as reference:
- `CountriesInteractor` - Business logic
- `ImagesInteractor` - Simple repository
- `UserPermissionsInteractor` - System integration

