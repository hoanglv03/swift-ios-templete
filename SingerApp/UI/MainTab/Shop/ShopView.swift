//
//  ShopView.swift
//  SingerApp
//

import SwiftUI

struct ShopView: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color.gray.opacity(0.1)
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    Image(systemName: "bag.fill")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .foregroundColor(.green)
                    
                    Text("Shop")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text("Welcome to Shop Screen")
                        .font(.body)
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Shop")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {}) {
                        Image(systemName: "magnifyingglass")
                    }
                }
            }
        }
    }
}

#Preview {
    ShopView()
}

