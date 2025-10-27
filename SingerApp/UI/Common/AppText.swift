//
//  AppText.swift
//  SingerApp
//
//  Common reusable Text component with variants

import SwiftUI

// MARK: - AppTextStyle

enum AppTextStyle {
    case largeTitle
    case title
    case title2
    case title3
    case headline
    case body
    case callout
    case subheadline
    case footnote
    case caption
    case caption2
    case custom(Font)
}

// MARK: - AppText

struct AppText: View {
    
    let text: String
    let style: AppTextStyle
    let color: Color
    let weight: Font.Weight
    let alignment: TextAlignment
    
    init(
        _ text: String,
        style: AppTextStyle = .body,
        color: Color = .primary,
        weight: Font.Weight = .regular,
        alignment: TextAlignment = .leading
    ) {
        self.text = text
        self.style = style
        self.color = color
        self.weight = weight
        self.alignment = alignment
    }
    
    var body: some View {
        Text(text)
            .font(font)
            .fontWeight(weight)
            .foregroundColor(color)
            .multilineTextAlignment(alignment)
    }
    
    private var font: Font {
        switch style {
        case .largeTitle:
            return .largeTitle
        case .title:
            return .title
        case .title2:
            return .title2
        case .title3:
            return .title3
        case .headline:
            return .headline
        case .body:
            return .body
        case .callout:
            return .callout
        case .subheadline:
            return .subheadline
        case .footnote:
            return .footnote
        case .caption:
            return .caption
        case .caption2:
            return .caption2
        case .custom(let customFont):
            return customFont
        }
    }
}

// MARK: - Convenience Initializers

extension AppText {
    
    // MARK: - Large Styles
    
    static func largeTitle(
        _ text: String,
        color: Color = .primary,
        weight: Font.Weight = .regular
    ) -> AppText {
        AppText(text, style: .largeTitle, color: color, weight: weight)
    }
    
    static func title(
        _ text: String,
        color: Color = .primary,
        weight: Font.Weight = .regular
    ) -> AppText {
        AppText(text, style: .title, color: color, weight: weight)
    }
    
    static func title2(
        _ text: String,
        color: Color = .primary,
        weight: Font.Weight = .regular
    ) -> AppText {
        AppText(text, style: .title2, color: color, weight: weight)
    }
    
    static func title3(
        _ text: String,
        color: Color = .primary,
        weight: Font.Weight = .regular
    ) -> AppText {
        AppText(text, style: .title3, color: color, weight: weight)
    }
    
    // MARK: - Medium Styles
    
    static func headline(
        _ text: String,
        color: Color = .primary,
        weight: Font.Weight = .semibold
    ) -> AppText {
        AppText(text, style: .headline, color: color, weight: weight)
    }
    
    static func body(
        _ text: String,
        color: Color = .primary,
        weight: Font.Weight = .regular
    ) -> AppText {
        AppText(text, style: .body, color: color, weight: weight)
    }
    
    static func callout(
        _ text: String,
        color: Color = .primary,
        weight: Font.Weight = .regular
    ) -> AppText {
        AppText(text, style: .callout, color: color, weight: weight)
    }
    
    // MARK: - Small Styles
    
    static func caption(
        _ text: String,
        color: Color = .secondary,
        weight: Font.Weight = .regular
    ) -> AppText {
        AppText(text, style: .caption, color: color, weight: weight)
    }
    
    static func footnote(
        _ text: String,
        color: Color = .secondary,
        weight: Font.Weight = .regular
    ) -> AppText {
        AppText(text, style: .footnote, color: color, weight: weight)
    }
}

// MARK: - View Modifiers

extension AppText {
    
    /// Apply text color
    func foreground(_ color: Color) -> AppText {
        AppText(text, style: style, color: color, weight: weight, alignment: alignment)
    }
    
    /// Apply font weight
    func weight(_ weight: Font.Weight) -> AppText {
        AppText(text, style: style, color: color, weight: weight, alignment: alignment)
    }
    
    /// Apply text alignment
    func textAlignment(_ alignment: TextAlignment) -> AppText {
        AppText(text, style: style, color: color, weight: weight, alignment: alignment)
    }
}

// MARK: - Building Custom Styles

extension AppText {
    
    /// Create custom font style
    static func custom(
        _ text: String,
        font: Font,
        color: Color = .primary,
        weight: Font.Weight = .regular
    ) -> AppText {
        AppText(text, style: .custom(font), color: color, weight: weight)
    }
}

// MARK: - Preview

#Preview("AppText Variants") {
    ScrollView {
        VStack(alignment: .leading, spacing: 20) {
            AppText.largeTitle("Large Title Text")
            AppText.title("Title Text")
            AppText.title2("Title 2 Text")
            AppText.title3("Title 3 Text")
            AppText.headline("Headline Text")
            AppText.body("Body Text - Regular")
            AppText.body("Body Text - Bold").weight(.bold)
            AppText.callout("Callout Text")
            AppText.caption("Caption Text")
            AppText.footnote("Footnote Text")
            
            Divider()
            
            AppText("Custom Color", style: .title, color: .blue)
            AppText("Red Alert", style: .headline, color: .red, weight: .bold)
            AppText("Gray Caption", style: .caption, color: .gray)
        }
        .padding()
    }
}

#Preview("Semantic Styles") {
    VStack(alignment: .leading, spacing: 16) {
        AppText.title("Primary Headline")
        AppText.body("Regular body text with normal weight")
        AppText.caption("Secondary caption text")
        AppText.body("Important text").weight(.semibold)
    }
    .padding()
}

