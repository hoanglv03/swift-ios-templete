//
//  AppTextField.swift
//  SingerApp
//
//  Common reusable TextField component with consistent styling

import SwiftUI

// MARK: - AppTextField Style

struct AppTextFieldStyle {
    var placeholder: String = ""
    var fontSize: Font = .body
    var cornerRadius: CGFloat = 8
    var borderWidth: CGFloat = 1
    var borderColor: Color = .gray.opacity(0.3)
    var backgroundColor: Color = .clear
    var padding: CGFloat = 12
}

// MARK: - AppTextField

struct AppTextField: View {
    
    @Binding var text: String
    let style: AppTextFieldStyle
    var keyboardType: UIKeyboardType = .default
    var secureField: Bool = false
    var autocapitalization: TextInputAutocapitalization = .sentences
    var autocorrection: Bool = true
    
    init(
        text: Binding<String>,
        style: AppTextFieldStyle = AppTextFieldStyle(),
        keyboardType: UIKeyboardType = .default,
        secureField: Bool = false,
        autocapitalization: TextInputAutocapitalization = .sentences,
        autocorrection: Bool = true
    ) {
        self._text = text
        self.style = style
        self.keyboardType = keyboardType
        self.secureField = secureField
        self.autocapitalization = autocapitalization
        self.autocorrection = autocorrection
    }
    
    var body: some View {
        textFieldView
            .font(style.fontSize)
            .padding(style.padding)
            .background(style.backgroundColor)
            .cornerRadius(style.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .stroke(style.borderColor, lineWidth: style.borderWidth)
            )
    }
    
    @ViewBuilder
    private var textFieldView: some View {
        if secureField {
            SecureField(style.placeholder, text: $text)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(autocapitalization)
                .autocorrectionDisabled(!autocorrection)
        } else {
            TextField(style.placeholder, text: $text)
                .keyboardType(keyboardType)
                .textInputAutocapitalization(autocapitalization)
                .autocorrectionDisabled(!autocorrection)
        }
    }
}

// MARK: - Predefined Styles

extension AppTextFieldStyle {
    
    /// Default text field style
    static var `default`: AppTextFieldStyle {
        AppTextFieldStyle()
    }
    
    /// Outlined style with border
    static var outlined: AppTextFieldStyle {
        AppTextFieldStyle(
            fontSize: .body,
            borderWidth: 1,
            borderColor: .gray.opacity(0.5)
        )
    }
    
    /// Filled style with background
    static var filled: AppTextFieldStyle {
        AppTextFieldStyle(
            fontSize: .body,
            borderWidth: 0, backgroundColor: .gray.opacity(0.1)
        )
    }
    
    /// Minimal style with thin border
    static var minimal: AppTextFieldStyle {
        AppTextFieldStyle(
            fontSize: .body,
            borderWidth: 0.5,
            borderColor: .gray.opacity(0.2)
        )
    }
    
    /// Large style for important inputs
    static var large: AppTextFieldStyle {
        AppTextFieldStyle(
            fontSize: .title3,
            borderWidth: 1.5, borderColor: .gray.opacity(0.4), padding: 16
        )
    }
}

// MARK: - Specialized Components

extension AppTextField {
    
    /// Email input field
    static func email(text: Binding<String>) -> AppTextField {
        AppTextField(
            text: text,
            style: .outlined,
            keyboardType: .emailAddress,
            autocapitalization: .never,
            autocorrection: false
        )
    }
    
    /// Password input field
    static func password(text: Binding<String>) -> AppTextField {
        AppTextField(
            text: text,
            style: .outlined,
            keyboardType: .default,
            secureField: true,
            autocapitalization: .never,
            autocorrection: false
        )
    }
    
    /// Number input field
    static func number(text: Binding<String>) -> AppTextField {
        AppTextField(
            text: text,
            style: .outlined,
            keyboardType: .numberPad
        )
    }
    
    /// Phone number input field
    static func phone(text: Binding<String>) -> AppTextField {
        AppTextField(
            text: text,
            style: .outlined,
            keyboardType: .phonePad
        )
    }
    
    /// URL input field
    static func url(text: Binding<String>) -> AppTextField {
        AppTextField(
            text: text,
            style: .outlined,
            keyboardType: .URL,
            autocapitalization: .never,
            autocorrection: false
        )
    }
}

// MARK: - View Modifier

extension View {
    
    /// Apply custom text field styling
    func appTextFieldStyle(
        placeholder: String = "",
        fontSize: Font = .body,
        cornerRadius: CGFloat = 8,
        borderWidth: CGFloat = 1,
        borderColor: Color = .gray.opacity(0.3),
        backgroundColor: Color = .clear,
        padding: CGFloat = 12
    ) -> some View {
        self.modifier(AppTextFieldModifier(
            style: AppTextFieldStyle(
                placeholder: placeholder,
                fontSize: fontSize,
                cornerRadius: cornerRadius,
                borderWidth: borderWidth,
                borderColor: borderColor,
                backgroundColor: backgroundColor,
                padding: padding
            )
        ))
    }
}

struct AppTextFieldModifier: ViewModifier {
    let style: AppTextFieldStyle
    
    func body(content: Content) -> some View {
        content
            .font(style.fontSize)
            .padding(style.padding)
            .background(style.backgroundColor)
            .cornerRadius(style.cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: style.cornerRadius)
                    .stroke(style.borderColor, lineWidth: style.borderWidth)
            )
    }
}

// MARK: - Preview

#Preview("AppTextField Styles") {
    ScrollView {
        VStack(spacing: 20) {
            AppTextField(
                text: .constant(""),
                style: .default,
                secureField: false
            )
            
            AppTextField(
                text: .constant(""),
                style: .outlined,
                secureField: false
            )
            
            AppTextField(
                text: .constant(""),
                style: .filled,
                secureField: false
            )
            
            AppTextField(
                text: .constant(""),
                style: .large,
                secureField: false
            )
            
            Divider()
            
            AppTextField.email(text: .constant(""))
            AppTextField.password(text: .constant(""))
            AppTextField.number(text: .constant(""))
            AppTextField.phone(text: .constant(""))
        }
        .padding()
    }
}

#Preview("AppTextField with Values") {
    VStack(spacing: 20) {
        AppTextField(
            text: .constant("john@example.com"),
            style: .outlined,
            keyboardType: .emailAddress
        )
        
        AppTextField(
            text: .constant("••••••••••"),
            style: .outlined,
            secureField: true
        )
    }
    .padding()
}

