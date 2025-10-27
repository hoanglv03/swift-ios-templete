# 📘 Common Components Guide

This guide explains how to use the reusable `AppText`, `AppTextField`, and `ImageView` components.

## 📋 Table of Contents

- [AppText Component](#apptext-component)
- [AppTextField Component](#apptextfield-component)
- [ImageView Component](#imageview-component)
- [Usage Examples](#usage-examples)
- [Best Practices](#best-practices)

---

## 📝 AppText Component

### Overview

`AppText` is a reusable text component that provides consistent typography throughout the app.

### Basic Usage

```swift
import SwiftUI

struct MyView: View {
    var body: some View {
        VStack {
            AppText.title("Welcome")
            AppText.body("This is body text")
            AppText.caption("This is a caption")
        }
    }
}
```

### Available Styles

```swift
// Large styles
AppText.largeTitle("Large Title")
AppText.title("Title")
AppText.title2("Title 2")
AppText.title3("Title 3")

// Medium styles
AppText.headline("Headline")
AppText.body("Body text")
AppText.callout("Callout")

// Small styles
AppText.caption("Caption")
AppText.footnote("Footnote")

// Custom font
AppText.custom("Custom text", font: .system(size: 24))
```

### Styling Modifiers

```swift
AppText.body("Bold text")
    .weight(.bold)

AppText.title("Blue text")
    .foreground(.blue)

AppText.headline("Centered text")
    .textAlignment(.center)
```

### Common Patterns

```swift
// Title with subtitle
VStack(alignment: .leading) {
    AppText.title("Screen Title")
    AppText.caption("Screen subtitle")
}

// Error message
AppText.body("Error occurred")
    .foreground(.red)
    .weight(.semibold)

// Success message
AppText.callout("Operation completed")
    .foreground(.green)

// Secondary information
AppText.caption("Last updated: 10 mins ago")
    .foreground(.gray)
```

---

## 🔐 AppTextField Component

### Overview

`AppTextField` provides consistent text input styling with multiple predefined styles.

### Basic Usage

```swift
struct MyView: View {
    @State private var username = ""
    
    var body: some View {
        AppTextField(
            text: $username,
            style: AppTextFieldStyle(placeholder: "Enter username")
        )
    }
}
```

### Available Styles

```swift
// Default style
AppTextField(text: $text, style: .default)

// Outlined border style  
AppTextField(text: $text, style: .outlined)

// Filled background style
AppTextField(text: $text, style: .filled)

// Minimal style
AppTextField(text: $text, style: .minimal)

// Large style for important inputs
AppTextField(text: $text, style: .large)

// Custom style with placeholder
AppTextField(
    text: $text, 
    style: AppTextFieldStyle(placeholder: "Enter text...")
)
```

### Specialized Input Types

```swift
// Email input
AppTextField.email(text: $email)

// Password input
AppTextField.password(text: $password)

// Number input
AppTextField.number(text: $number)

// Phone number input
AppTextField.phone(text: $phone)

// URL input
AppTextField.url(text: $url)
```

### Complete Example

```swift
struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 16) {
            AppText.title("Login")
            
            AppTextField(
                text: $email,
                style: .outlined,
                keyboardType: .emailAddress
            )
            
            AppTextField(
                text: $password,
                style: .outlined,
                secureField: true
            )
            
            Button("Sign In") {
                // Login logic
            }
        }
        .padding()
    }
}
```

---

## 💡 Usage Examples

### Example 1: User Profile

```swift
struct UserProfileView: View {
    @State private var name = ""
    @State private var bio = ""
    
    var body: some View {
        Form {
            Section {
                AppTextField(
                    text: $name,
                    style: AppTextFieldStyle(placeholder: "Name")
                )
            }
            
            Section {
            AppTextField(
                text: $bio,
                style: AppTextFieldStyle(placeholder: "Bio")
            )
                .lineLimit(5)
            }
        }
        .navigationTitle("Profile")
    }
}
```

### Example 2: Search Interface

```swift
struct SearchView: View {
    @State private var searchText = ""
    
    var body: some View {
        VStack(alignment: .leading) {
            AppText.title("Search")
            
            AppTextField(
                text: $searchText,
                style: .filled
            )
            
            AppText.caption("Type to search")
                .foreground(.gray)
        }
        .padding()
    }
}
```

### Example 3: Form with Validation

```swift
struct ContactFormView: View {
    @State private var name = ""
    @State private var email = ""
    @State private var message = ""
    @State private var hasError = false
    
    var body: some View {
        Form {
            Section {
                AppTextField(
                    text: $name,
                    style: AppTextFieldStyle(placeholder: "Name")
                )
                
                if hasError && name.isEmpty {
                    AppText.caption("Name is required")
                        .foreground(.red)
                }
            }
            
            Section {
                AppTextField.email(text: $email)
                
                if hasError && email.isEmpty {
                    AppText.caption("Email is required")
                        .foreground(.red)
                }
            }
            
            Section {
            AppTextField(
                text: $message,
                style: AppTextFieldStyle(placeholder: "Message")
            )
                .lineLimit(10)
            }
        }
        .navigationTitle("Contact")
        .toolbar {
            Button("Submit") {
                validate()
            }
        }
    }
    
    private func validate() {
        hasError = name.isEmpty || email.isEmpty
    }
}
```

---

## ✅ Best Practices

### AppText

1. **Use semantic styles**: Prefer `.headline` for titles, `.body` for content, `.caption` for metadata
2. **Consistent hierarchy**: Use `.title` for primary, `.headline` for secondary, `.caption` for tertiary
3. **Color wisely**: Use `.foreground()` sparingly, default colors work for most cases
4. **Limit modifiers**: Don't chain too many modifiers, prefer multiple components

```swift
// ✅ Good
VStack(alignment: .leading) {
    AppText.title("Title")
    AppText.body("Description")
}

// ❌ Avoid
AppText.body("Text")
    .weight(.bold)
    .foreground(.blue)
    .alignment(.center)
    .font(.title)  // Mixed priorities
```

### AppTextField

1. **Use specialized types**: Prefer `AppTextField.email()` over generic text field
2. **Match style to context**: Use `.large` for important inputs, `.minimal` for search
3. **Provide placeholders**: Always include meaningful placeholder text
4. **Handle secure fields**: Use `AppTextField.password()` for sensitive data

```swift
// ✅ Good
AppTextField.email(text: $email)
AppTextField.password(text: $password)

// ❌ Avoid
AppTextField(text: $email, style: .outlined, keyboardType: .emailAddress)
```

### Combining Components

```swift
struct FormSection: View {
    let title: String
    @Binding var value: String
    var placeholder: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            AppText.headline(title)
                AppTextField(
                    text: $value,
                    style: AppTextFieldStyle(placeholder: placeholder)
                )
        }
    }
}

// Usage
FormSection(
    title: "Email",
    value: $email,
    placeholder: "Enter your email"
)
```

---

## 🎨 Style Reference

### Text Hierarchy

```text
LargeTitle  →  Highest importance
Title       →  Section headers
Title2      →  Subsection headers
Title3      →  Minor headers
Headline    →  Emphasized content
Body        →  Regular content
Callout     →  Supporting text
Caption     →  Metadata, hints
Footnote    →  Additional info
```

### Input Styles

```text
Default     →  Standard border
Outlined    →  Prominent border
Filled      →  Background color
Minimal     →  Thin border
Large       →  Bigger, prominent
```

---

## 🖼️ ImageView Component

### Overview

`ImageView` is a component that loads and displays images from URLs asynchronously with built-in loading states and error handling.

### Basic Usage

```swift
import SwiftUI

struct MyView: View {
    let imageURL = URL(string: "https://example.com/image.jpg")!
    
    var body: some View {
        ImageView(imageURL: imageURL)
    }
}
```

### Features

- **Async Loading**: Automatically loads images from URL
- **Loading States**: Shows progress indicator while loading
- **Error Handling**: Displays error message on failure
- **Cache Support**: Integrates with ImagesInteractor for caching
- **Dependency Injection**: Uses DIContainer for image loading

### How It Works

`ImageView` uses the `Loadable` pattern to manage different states:

```swift
enum Loadable<Value> {
    case notRequested     // Initial state
    case isLoading       // Loading from URL
    case loaded(Value)   // Successfully loaded image
    case failed(Error)   // Loading failed
}
```

### Basic Example

```swift
struct CountryFlagView: View {
    let country: Country
    
    var body: some View {
        ImageView(imageURL: country.flagURL)
            .frame(width: 100, height: 60)
            .cornerRadius(8)
    }
}
```

### Advanced Usage

```swift
struct ProfileImageView: View {
    let avatarURL: URL
    
    var body: some View {
        ImageView(imageURL: avatarURL)
            .frame(width: 80, height: 80)
            .clipShape(Circle())
            .overlay(
                Circle()
                    .stroke(Color.blue, lineWidth: 2)
            )
    }
}
```

### Loading States

The component automatically handles all states:

```swift
// State 1: Not Requested
// Automatically triggers load onAppear

// State 2: Loading
// Displays ProgressView()

// State 3: Loaded  
// Displays the UIImage

// State 4: Failed
// Shows "Unable to load image" message
```

### Example with Custom Initial State

```swift
struct GalleryView: View {
    @State private var images: [Loadable<UIImage>] = []
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))]) {
                ForEach(images.indices, id: \.self) { index in
                    ImageView(
                        imageURL: URLs[index],
                        image: images[index]
                    )
                    .aspectRatio(1, contentMode: .fit)
                }
            }
        }
    }
}
```

### Integration with DIContainer

The component automatically injects dependencies:

```swift
@Environment(\.injected) var injected: DIContainer
```

This allows it to use the `ImagesInteractor` for loading images.

### Testing Support

The component includes `inspection` for unit testing:

```swift
let inspection = Inspection<Self>()

// In tests
let view = ImageView(imageURL: testURL)
try await view.inspection.inspect { view in
    // Assert view state
}
```

### Best Practices

1. **Always provide URL**: Ensure the URL is valid
2. **Use appropriate frames**: Set size for best layout
3. **Handle errors gracefully**: Component shows error automatically
4. **Use with URLs**: Designed for remote images, not local assets

```swift
// ✅ Good - Using URL
ImageView(imageURL: country.flagURL)

// ✅ Good - With frame
ImageView(imageURL: avatarURL)
    .frame(width: 80, height: 80)

// ❌ Avoid - Don't use for local assets
// ImageView(imageURL: Bundle.main.url(forResource: "local.png"))
// Use Image("local.png") instead
```

### Complete Example

```swift
struct UserAvatarView: View {
    let user: User
    
    var body: some View {
        VStack {
            ImageView(imageURL: user.avatarURL)
                .frame(width: 120, height: 120)
                .clipShape(Circle())
                .shadow(radius: 8)
            
            AppText.title(user.name)
        }
    }
}
```

---

## 🔍 API Reference

See the full API documentation in source files:
- `SingerApp/UI/Common/AppText.swift`
- `SingerApp/UI/Common/AppTextField.swift`
- `SingerApp/UI/Common/ImageView.swift`
