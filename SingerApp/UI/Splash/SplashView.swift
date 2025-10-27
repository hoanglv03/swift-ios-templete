//
//  SplashView.swift
//  SingerApp
//

import SwiftUI

struct SplashView: View {
    @State private var isActive = false
    @Environment(\.injected) private var injected: DIContainer
    
    var body: some View {
        ZStack {
            Color.blue
                .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "app.fill")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white)
                
                Text("SingerApp")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
        .fullScreenCover(isPresented: $isActive) {
            // For now, go directly to main tab
            // Later we'll add authentication logic
            MainTabView()
        }
    }
}

#Preview {
    SplashView()
}

