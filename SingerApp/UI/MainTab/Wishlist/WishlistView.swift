//
//  WishlistView.swift
//  SingerApp
//

import SwiftUI

struct WishlistView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.1)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.red)
                    
                    Text("Wishlist")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Welcome to Wishlist Screen")
                        .font(.body)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Wishlist")
        }
    }
}

#Preview {
    WishlistView()
}

